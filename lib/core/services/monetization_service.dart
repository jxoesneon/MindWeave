import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/subscription_tier.dart';
import '../models/donation.dart';
import 'remote_config_service.dart';

/// Monetization service using in_app_purchase directly (no RevenueCat).
///
/// Handles one-time donations and subscription tiers via
/// Apple App Store / Google Play billing.
class MonetizationService {
  static final MonetizationService _instance = MonetizationService._internal();
  factory MonetizationService() => _instance;
  MonetizationService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final Logger _logger = Logger('MonetizationService');
  final RemoteConfigService _remoteConfig = RemoteConfigService();
  final Uuid _uuid = const Uuid();

  bool _isInitialized = false;
  bool _isAvailable = false;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  String? _activeTierId;

  // Product IDs mapped to store
  static const _kDonation3 = 'mindweave_donate_3';
  static const _kDonation5 = 'mindweave_donate_5';
  static const _kDonation10 = 'mindweave_donate_10';
  static const _kDonation25 = 'mindweave_donate_25';
  static const _kSubSupporter = 'mindweave_supporter_monthly';
  static const _kSubAdvocate = 'mindweave_advocate_monthly';
  static const _kSubChampion = 'mindweave_champion_monthly';

  static const _allProductIds = {
    _kDonation3,
    _kDonation5,
    _kDonation10,
    _kDonation25,
    _kSubSupporter,
    _kSubAdvocate,
    _kSubChampion,
  };

  // Stream controllers
  final StreamController<List<Donation>> _donationsController =
      StreamController<List<Donation>>.broadcast();
  final StreamController<bool> _premiumStatusController =
      StreamController<bool>.broadcast();

  Stream<List<Donation>> get donationsStream => _donationsController.stream;
  Stream<bool> get premiumStatusStream => _premiumStatusController.stream;

  bool get isPremiumActive => _activeTierId != null;
  bool get isSupporter => _activeTierId == 'supporter';
  bool get isAdvocate => _activeTierId == 'advocate';
  bool get isChampion => _activeTierId == 'champion';
  SubscriptionTier? get currentTier => _getCurrentTier();
  List<ProductDetails> get products => _products;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isAvailable = await _inAppPurchase.isAvailable();
      if (!_isAvailable) {
        _logger.warning('In-app purchases not available on this device');
      }

      // Set up purchase listener
      _setupPurchaseListener();

      // Load products from store
      if (_isAvailable) {
        await _loadProducts();
      }

      // Restore previous purchases
      await _restoreLocalTier();

      // Load donation history
      await _loadDonationHistory();

      _isInitialized = true;
      _logger.info('Monetization service initialized');
    } catch (e) {
      _logger.severe('Failed to initialize monetization service: $e');
    }
  }

  Future<void> _loadProducts() async {
    final response = await _inAppPurchase.queryProductDetails(_allProductIds);
    if (response.notFoundIDs.isNotEmpty) {
      _logger.warning('Products not found: ${response.notFoundIDs}');
    }
    _products = response.productDetails;
    _logger.info('Loaded ${_products.length} products');
  }

  void _setupPurchaseListener() {
    _subscription = _inAppPurchase.purchaseStream.listen(
      (purchaseDetailsList) => _handlePurchaseUpdates(purchaseDetailsList),
      onDone: () => _subscription?.cancel(),
      onError: (error) => _logger.severe('Purchase stream error: $error'),
    );
  }

  Future<void> _restoreLocalTier() async {
    final prefs = await SharedPreferences.getInstance();
    _activeTierId = prefs.getString('active_tier_id');
    _premiumStatusController.add(isPremiumActive);
  }

  /// Purchase a product by its store ID.
  Future<bool> purchaseProduct(String productId) async {
    if (!_isAvailable) return false;

    final matches = _products.where((p) => p.id == productId);
    if (matches.isEmpty) {
      _logger.warning('Product not found: $productId');
      return false;
    }
    final product = matches.first;

    final purchaseParam = PurchaseParam(productDetails: product);

    // Subscriptions vs consumables
    if (productId.contains('monthly')) {
      return _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } else {
      return _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    }
  }

  /// Purchase a subscription tier.
  Future<bool> purchaseSubscription(SubscriptionTier tier) async {
    final productId = switch (tier.id) {
      'supporter' => _kSubSupporter,
      'advocate' => _kSubAdvocate,
      'champion' => _kSubChampion,
      _ => null,
    };
    if (productId == null) return false;
    return purchaseProduct(productId);
  }

  Future<void> makeDonation({
    required double amount,
    required DonationType type,
    String? message,
    bool isMonthly = false,
  }) async {
    try {
      final donation = Donation(
        id: _uuid.v4(),
        userId: Supabase.instance.client.auth.currentSession?.user.id ??
            'anonymous',
        amount: amount,
        type: type,
        message: message,
        isMonthly: isMonthly,
        status: DonationStatus.pending,
        createdAt: DateTime.now(),
      );

      // Save to local storage first
      await _saveDonationLocally(donation);

      // Try to process through payment provider
      if (type == DonationType.oneTime) {
        await _processOneTimeDonation(donation);
      } else {
        await _processMonthlyDonation(donation);
      }

      // Update donation status
      final completedDonation = donation.copyWith(
        status: DonationStatus.completed,
        processedAt: DateTime.now(),
      );

      await _updateDonationInDatabase(completedDonation);
      await _loadDonationHistory();
    } catch (e) {
      _logger.severe('Failed to process donation: $e');
      rethrow;
    }
  }

  Future<void> _processOneTimeDonation(Donation donation) async {
    try {
      if (Platform.isIOS || Platform.isAndroid) {
        // Map amount to product ID
        final productId = switch (donation.amount.round()) {
          3 => _kDonation3,
          5 => _kDonation5,
          10 => _kDonation10,
          25 => _kDonation25,
          _ => null,
        };
        if (productId != null) {
          await purchaseProduct(productId);
        } else {
          await _openExternalPaymentPage(donation);
        }
      } else {
        await _openExternalPaymentPage(donation);
      }
    } catch (e) {
      _logger.severe('Failed to process one-time donation: $e');
      rethrow;
    }
  }

  Future<void> _processMonthlyDonation(Donation donation) async {
    try {
      await purchaseSubscription(_getTierForAmount(donation.amount));
    } catch (e) {
      _logger.severe('Failed to process monthly donation: $e');
      rethrow;
    }
  }

  Future<void> _openExternalPaymentPage(Donation donation) async {
    try {
      final url = Uri.parse(
        'https://your-payment-processor.com/donate'
        '?amount=${donation.amount}'
        '&currency=USD'
        '&message=${Uri.encodeComponent(donation.message ?? '')}'
        '&reference=${donation.id}',
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch payment URL');
      }
    } catch (e) {
      _logger.severe('Failed to open payment page: $e');
      rethrow;
    }
  }

  SubscriptionTier _getTierForAmount(double amount) {
    if (amount >= _remoteConfig.championPrice) {
      return SubscriptionTier.champion;
    } else if (amount >= _remoteConfig.advocatePrice) {
      return SubscriptionTier.advocate;
    } else {
      return SubscriptionTier.supporter;
    }
  }

  Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      _logger.info('Purchases restored successfully');
    } catch (e) {
      _logger.severe('Failed to restore purchases: $e');
      rethrow;
    }
  }

  Future<List<Donation>> getDonationHistory() async {
    try {
      final userId = Supabase.instance.client.auth.currentSession?.user.id;
      if (userId == null) return [];

      final response = await Supabase.instance.client
          .from('donations')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Donation.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      _logger.severe('Failed to fetch donation history: $e');
      return [];
    }
  }

  Future<double> getTotalDonations() async {
    try {
      final donations = await getDonationHistory();
      final completedDonations =
          donations.where((d) => d.status == DonationStatus.completed).toList();

      return completedDonations.fold<double>(
        0.0,
        (sum, donation) => sum + donation.amount,
      );
    } catch (e) {
      _logger.severe('Failed to calculate total donations: $e');
      return 0.0;
    }
  }

  Future<FundingProgress> getFundingProgress() async {
    try {
      // Get total donations from all users
      final response = await Supabase.instance.client
          .from('donations')
          .select('amount')
          .eq('status', 'completed');

      final totalAmount = (response as List).fold<double>(
        0.0,
        (sum, donation) => sum + (donation['amount'] as num).toDouble(),
      );

      final goalAmount = _remoteConfig.donationGoalAmount;
      final supporterCount = await _getSupporterCount();

      return FundingProgress(
        currentAmount: totalAmount,
        goalAmount: goalAmount,
        percentage: (totalAmount / goalAmount).clamp(0.0, 1.0),
        supporterCount: supporterCount,
      );
    } catch (e) {
      _logger.severe('Failed to get funding progress: $e');
      return FundingProgress.empty();
    }
  }

  Future<int> _getSupporterCount() async {
    try {
      final response = await Supabase.instance.client
          .from('donations')
          .select('user_id')
          .eq('status', 'completed')
          .neq('user_id', 'anonymous');

      final uniqueUsers = <String>{};
      for (final donation in response as List) {
        uniqueUsers.add(donation['user_id'] as String);
      }

      return uniqueUsers.length;
    } catch (e) {
      _logger.warning('Failed to get supporter count: $e');
      return 0;
    }
  }

  Future<void> updateSubscriptionTier(SubscriptionTier newTier) async {
    try {
      await purchaseSubscription(newTier);
    } catch (e) {
      _logger.severe('Failed to update subscription tier: $e');
      rethrow;
    }
  }

  Future<void> checkSubscriptionStatus() async {
    try {
      await _restoreLocalTier();
    } catch (e) {
      _logger.warning('Failed to check subscription status: $e');
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      _handlePurchase(purchaseDetails);
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    try {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          _logger.info('Purchase pending: ${purchaseDetails.productID}');
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _logger.info('Purchase successful: ${purchaseDetails.productID}');

          // Determine tier from product ID
          if (purchaseDetails.productID.contains('supporter')) {
            _activeTierId = 'supporter';
          } else if (purchaseDetails.productID.contains('advocate')) {
            _activeTierId = 'advocate';
          } else if (purchaseDetails.productID.contains('champion')) {
            _activeTierId = 'champion';
          }

          // Persist tier
          final prefs = await SharedPreferences.getInstance();
          if (_activeTierId != null) {
            await prefs.setString('active_tier_id', _activeTierId!);
          }
          _premiumStatusController.add(isPremiumActive);

          // Complete the purchase on the platform
          if (purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
          break;
        case PurchaseStatus.error:
          _logger.severe('Purchase error: ${purchaseDetails.error}');
          break;
        case PurchaseStatus.canceled:
          _logger.info('Purchase canceled: ${purchaseDetails.productID}');
          break;
      }
    } catch (e) {
      _logger.severe('Error handling purchase: $e');
    }
  }

  Future<void> _saveDonationLocally(Donation donation) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final donations = prefs.getStringList('local_donations') ?? [];
      donations.add(donation.toJson().toString());
      await prefs.setStringList('local_donations', donations);
    } catch (e) {
      _logger.warning('Failed to save donation locally: $e');
    }
  }

  Future<void> _updateDonationInDatabase(Donation donation) async {
    try {
      await Supabase.instance.client
          .from('donations')
          .upsert(donation.toJson());
    } catch (e) {
      _logger.warning('Failed to update donation in database: $e');
    }
  }

  Future<void> _loadDonationHistory() async {
    try {
      final donations = await getDonationHistory();
      _donationsController.add(donations);
    } catch (e) {
      _logger.warning('Failed to load donation history: $e');
    }
  }

  SubscriptionTier? _getCurrentTier() {
    if (isChampion) return SubscriptionTier.champion;
    if (isAdvocate) return SubscriptionTier.advocate;
    if (isSupporter) return SubscriptionTier.supporter;
    if (isPremiumActive) return SubscriptionTier.premium;
    return SubscriptionTier.free;
  }

  bool hasFeatureAccess(String feature) {
    switch (feature) {
      case 'premium_presets':
        return isPremiumActive;
      case 'music_mixing':
        return isPremiumActive;
      case 'session_history':
        return isPremiumActive;
      case 'custom_presets':
        return isAdvocate || isChampion;
      case 'beta_access':
        return isAdvocate || isChampion;
      case 'roadmap_input':
        return isChampion;
      default:
        return true;
    }
  }

  void dispose() {
    _subscription?.cancel();
    _donationsController.close();
    _premiumStatusController.close();
  }
}

class FundingProgress {
  final double currentAmount;
  final double goalAmount;
  final double percentage;
  final int supporterCount;

  const FundingProgress({
    required this.currentAmount,
    required this.goalAmount,
    required this.percentage,
    required this.supporterCount,
  });

  static FundingProgress empty() => const FundingProgress(
        currentAmount: 0.0,
        goalAmount: 500.0,
        percentage: 0.0,
        supporterCount: 0,
      );

  String get formattedCurrentAmount => '\$${currentAmount.toStringAsFixed(2)}';
  String get formattedGoalAmount => '\$${goalAmount.toStringAsFixed(2)}';
  String get formattedPercentage => '${(percentage * 100).toStringAsFixed(1)}%';
  String get formattedSupporterCount => supporterCount.toString();
}
