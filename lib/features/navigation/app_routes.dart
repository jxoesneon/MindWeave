import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import '../notifications/notifications_screen.dart';
import '../explore/explore_screen.dart';
import '../explore/favorite_nodes_screen.dart';
import '../timer/sonic_sanctuary_screen.dart';
import '../learn/learn_screen.dart';
import '../learn/deep_resonance_screen.dart';
import '../journal/celestial_journal_screen.dart';
import '../support/support_screen.dart';
import '../transparency/transparency_hub_screen.dart';
import '../transparency/financial_ledger_screen.dart';
import '../legal/terms_of_service_screen.dart';
import '../legal/privacy_policy_screen.dart';
import '../legal/open_source_screen.dart';
import '../documentation/documentation_screen.dart';
import '../payment/crypto_payment_screen.dart';
import '../payment/crypto_faq_screen.dart';
import '../payment/digital_wallets_screen.dart';
import '../payment/payment_methods_screen.dart';
import '../payment/tier_payment_screen.dart';
import '../payment/subscription_success_screen.dart';
import '../payment/support_us_screen.dart';

/// Centralized route names for all app screens.
///
/// Usage:
/// ```dart
/// Navigator.pushNamed(context, AppRoutes.profile);
/// ```
class AppRoutes {
  AppRoutes._();

  // Core screens
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String explore = '/explore';
  static const String favoriteNodes = '/favorite-nodes';
  static const String sonicSanctuary = '/sonic-sanctuary';

  // Learn / Education
  static const String learn = '/learn';
  static const String deepResonance = '/deep-resonance';

  // Support
  static const String support = '/support';

  // Transparency / Finance
  static const String transparencyHub = '/transparency';
  static const String financialLedger = '/financial-ledger';

  // Legal
  static const String termsOfService = '/terms-of-service';
  static const String privacyPolicy = '/privacy-policy';
  static const String openSource = '/open-source';

  // Journal
  static const String celestialJournal = '/celestial-journal';
  static const String documentation = '/documentation';

  // Payment / Subscription
  static const String cryptoPayment = '/crypto-payment';
  static const String cryptoFaq = '/crypto-faq';
  static const String digitalWallets = '/digital-wallets';
  static const String paymentMethods = '/payment-methods';
  static const String tierPayment = '/tier-payment';
  static const String subscriptionSuccess = '/subscription-success';
  static const String supportUs = '/support-us';

  /// Route map for [MaterialApp.routes].
  static Map<String, WidgetBuilder> get routes => {
    profile: (_) => const ProfileScreen(),
    notifications: (_) => const NotificationsScreen(),
    explore: (_) => const ExploreScreen(),
    favoriteNodes: (_) => const FavoriteNodesScreen(),
    sonicSanctuary: (_) => const SonicSanctuaryScreen(),
    learn: (_) => const LearnScreen(),
    deepResonance: (_) => const DeepResonanceScreen(),
    celestialJournal: (_) => const CelestialJournalScreen(),
    support: (_) => const SupportScreen(),
    transparencyHub: (_) => const TransparencyHubScreen(),
    financialLedger: (_) => const FinancialLedgerScreen(),
    termsOfService: (_) => const TermsOfServiceScreen(),
    privacyPolicy: (_) => const PrivacyPolicyScreen(),
    openSource: (_) => const OpenSourceScreen(),
    documentation: (_) => const DocumentationScreen(),
    cryptoPayment: (_) => const CryptoPaymentScreen(),
    cryptoFaq: (_) => const CryptoFaqScreen(),
    digitalWallets: (_) => const DigitalWalletsScreen(),
    paymentMethods: (_) => const PaymentMethodsScreen(),
    tierPayment: (_) => const TierPaymentScreen(),
    subscriptionSuccess: (_) => const SubscriptionSuccessScreen(),
    supportUs: (_) => const SupportUsScreen(),
  };
}
