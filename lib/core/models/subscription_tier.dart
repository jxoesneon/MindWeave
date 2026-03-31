import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_tier.freezed.dart';
part 'subscription_tier.g.dart';

@freezed
abstract class SubscriptionTier with _$SubscriptionTier {
  const factory SubscriptionTier({
    required String id,
    required String name,
    required String description,
    required double monthlyPrice,
    required double yearlyPrice,
    required List<String> features,
    required int sortOrder,
    @Default(false) bool isPopular,
    @Default('#000000') String color,
    Map<String, dynamic>? metadata,
  }) = _SubscriptionTier;

  factory SubscriptionTier.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionTierFromJson(json);

  const SubscriptionTier._();

  // Predefined tiers
  static const free = SubscriptionTier(
    id: 'free',
    name: 'Free',
    description: 'Basic meditation features',
    monthlyPrice: 0.0,
    yearlyPrice: 0.0,
    features: ['Basic binaural beats', '5 minute sessions', 'Limited presets'],
    sortOrder: 0,
    color: '#6B7280',
  );

  static const premium = SubscriptionTier(
    id: 'premium',
    name: 'Premium',
    description: 'Unlock full meditation experience',
    monthlyPrice: 9.99,
    yearlyPrice: 79.99,
    features: [
      'All binaural beat presets',
      'Unlimited session length',
      'Music mixing',
      'Session history',
      'No ads',
    ],
    sortOrder: 1,
    color: '#3B82F6',
  );

  static const supporter = SubscriptionTier(
    id: 'supporter',
    name: 'Supporter',
    description: 'Support app development',
    monthlyPrice: 15.0,
    yearlyPrice: 120.0,
    features: [
      'Everything in Premium',
      'Custom presets',
      'Priority support',
      'Supporter badge',
      'Early access to features',
    ],
    sortOrder: 2,
    isPopular: true,
    color: '#10B981',
  );

  static const advocate = SubscriptionTier(
    id: 'advocate',
    name: 'Advocate',
    description: 'Become an advocate for mindful living',
    monthlyPrice: 25.0,
    yearlyPrice: 200.0,
    features: [
      'Everything in Supporter',
      'Beta access',
      'Community voting',
      'Advocate badge',
      'Monthly group meditation',
    ],
    sortOrder: 3,
    color: '#8B5CF6',
  );

  static const champion = SubscriptionTier(
    id: 'champion',
    name: 'Champion',
    description: 'Lead the mindfulness movement',
    monthlyPrice: 50.0,
    yearlyPrice: 400.0,
    features: [
      'Everything in Advocate',
      'Roadmap input',
      'Personal thank you',
      'Champion badge',
      '1-on-1 session with founder',
      'Lifetime access to new features',
    ],
    sortOrder: 4,
    color: '#F59E0B',
  );

  // Get all tiers
  static List<SubscriptionTier> get allTiers => [
    free,
    premium,
    supporter,
    advocate,
    champion,
  ];

  // Get paid tiers
  static List<SubscriptionTier> get paidTiers =>
      allTiers.where((tier) => tier.monthlyPrice > 0).toList();

  // Get tier by ID
  static SubscriptionTier? getById(String id) {
    try {
      return allTiers.firstWhere((tier) => tier.id == id);
    } catch (e) {
      return null;
    }
  }

  // Helper methods
  String get formattedMonthlyPrice =>
      monthlyPrice == 0.0 ? 'Free' : '\$${monthlyPrice.toStringAsFixed(2)}/mo';

  String get formattedYearlyPrice =>
      yearlyPrice == 0.0 ? 'Free' : '\$${yearlyPrice.toStringAsFixed(2)}/yr';

  String get formattedSavings {
    if (monthlyPrice == 0.0 || yearlyPrice == 0.0) return '';
    final yearlyMonthly = monthlyPrice * 12;
    final savings = yearlyMonthly - yearlyPrice;
    return 'Save \$${savings.toStringAsFixed(0)}/year';
  }

  bool get isFree => monthlyPrice == 0.0;
  bool get isPaid => monthlyPrice > 0.0;

  int get maxCustomPresets {
    switch (id) {
      case 'free':
        return 0;
      case 'premium':
        return 3;
      case 'supporter':
        return 10;
      case 'advocate':
        return 25;
      case 'champion':
        return -1; // Unlimited
      default:
        return 0;
    }
  }

  bool get hasMusicMixing {
    return ['premium', 'supporter', 'advocate', 'champion'].contains(id);
  }

  bool get hasSessionHistory {
    return ['premium', 'supporter', 'advocate', 'champion'].contains(id);
  }

  bool get hasCustomPresets {
    return ['supporter', 'advocate', 'champion'].contains(id);
  }

  bool get hasBetaAccess {
    return ['advocate', 'champion'].contains(id);
  }

  bool get hasRoadmapInput {
    return id == 'champion';
  }

  bool get hasPrioritySupport {
    return ['supporter', 'advocate', 'champion'].contains(id);
  }

  bool get hasCommunityVoting {
    return ['advocate', 'champion'].contains(id);
  }

  bool get hasGroupMeditation {
    return ['advocate', 'champion'].contains(id);
  }

  bool get hasPersonalSession {
    return id == 'champion';
  }

  bool get hasLifetimeAccess {
    return id == 'champion';
  }

  List<String> get badgeNames {
    switch (id) {
      case 'supporter':
        return ['Supporter'];
      case 'advocate':
        return ['Supporter', 'Advocate'];
      case 'champion':
        return ['Supporter', 'Advocate', 'Champion'];
      default:
        return [];
    }
  }

  String get badgeEmoji {
    switch (id) {
      case 'supporter':
        return '🌟';
      case 'advocate':
        return '💎';
      case 'champion':
        return '👑';
      default:
        return '';
    }
  }
}

extension SubscriptionTierExtension on SubscriptionTier {
  bool isHigherThan(SubscriptionTier other) {
    return sortOrder > other.sortOrder;
  }

  bool isLowerThan(SubscriptionTier other) {
    return sortOrder < other.sortOrder;
  }

  bool isSameOrHigherThan(SubscriptionTier other) {
    return sortOrder >= other.sortOrder;
  }

  bool isSameOrLowerThan(SubscriptionTier other) {
    return sortOrder <= other.sortOrder;
  }
}
