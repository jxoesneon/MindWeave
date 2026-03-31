import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/analytics_service.dart';
import '../../features/health/health_controller.dart';
import 'theme_controller.dart';

final analyticsEnabledProvider = FutureProvider<bool>((ref) async {
  return AnalyticsService().isOptedIn();
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final themeMode = ref.watch(themeModeProvider);
    final healthState = ref.watch(healthControllerProvider);

    final isDarkMode = themeMode.when(
      data: (mode) => mode == ThemeMode.dark,
      loading: () => true,
      error: (_, _) => true,
    );

    final isHealthSyncEnabled = healthState.when(
      data: (state) => state.todayMindfulMinutes != null,
      loading: () => false,
      error: (_, _) => false,
    );

    if (isDesktop) {
      return _buildDesktopLayout(
        context,
        ref,
        healthState,
        isDarkMode,
        isHealthSyncEnabled,
      );
    }

    return _buildMobileLayout(
      context,
      ref,
      healthState,
      isDarkMode,
      isHealthSyncEnabled,
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<HealthState> healthState,
    bool isDarkMode,
    bool isHealthSyncEnabled,
  ) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.onSurface,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Support Us',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),

            // Hero Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(26),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Thank You for Using\nMindWeave!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This app is free because of supporters like you.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Funding Goal Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer.withAlpha(153),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.outlineVariant.withAlpha(77),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Monthly Goal: \$500',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(51),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '60%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: const LinearProgressIndicator(
                          value: 0.6,
                          backgroundColor: AppColors.surfaceContainerHigh,
                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Current: \$300 from 45 supporters',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Help us reach our goal!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // One-Time Donation Section
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 32, 20, 16),
                child: Text(
                  'Support with a one-time gift',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _DonationChip(
                      amount: '\$3',
                      isSelected: false,
                      onTap: () {},
                    ),
                    _DonationChip(
                      amount: '\$5',
                      isSelected: false,
                      onTap: () {},
                    ),
                    _DonationChip(
                      amount: '\$10',
                      isSelected: true,
                      onTap: () {},
                    ),
                    _DonationChip(
                      amount: '\$25',
                      isSelected: false,
                      onTap: () {},
                    ),
                    _DonationChip(
                      amount: 'Custom',
                      isSelected: false,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            // Monthly Supporter Tiers
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 32, 20, 16),
                child: Text(
                  'Or become a monthly supporter',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: const [
                    _TierCard(
                      title: 'Supporter',
                      price: '\$2',
                      period: '/mo',
                      icon: Icons.workspace_premium,
                      benefits: ['In-app badge'],
                      gradientColors: [
                        AppColors.primary,
                        AppColors.primaryContainer,
                      ],
                    ),
                    SizedBox(width: 12),
                    _TierCard(
                      title: 'Advocate',
                      price: '\$5',
                      period: '/mo',
                      icon: Icons.stars,
                      benefits: ['Badge + name', 'Early access'],
                      gradientColors: [AppColors.secondary, AppColors.primary],
                    ),
                    SizedBox(width: 12),
                    _TierCard(
                      title: 'Champion',
                      price: '\$10',
                      period: '/mo',
                      icon: Icons.diamond,
                      benefits: ['All benefits', 'Roadmap input'],
                      gradientColors: [AppColors.tertiary, AppColors.primary],
                    ),
                  ],
                ),
              ),
            ),

            // Payment Button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.payment, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Donate with Apple Pay',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Other Payment Options',
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Transparency Links
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _LinkButton(
                      icon: Icons.open_in_new,
                      label: 'View Our Open Collective',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _LinkButton(
                      icon: Icons.info,
                      label: 'See How Funds Are Used',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            // Settings Section
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 16),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _SettingsToggle(
                      icon: Icons.dark_mode,
                      label: 'Dark Mode',
                      value: isDarkMode,
                      onChanged: (v) {
                        ref.read(themeModeProvider.notifier).toggleTheme();
                      },
                    ),
                    const SizedBox(height: 8),
                    _SettingsToggle(
                      icon: Icons.headphones,
                      label: 'Background Playback',
                      value: true,
                      onChanged: (v) {},
                    ),
                    const SizedBox(height: 8),
                    _SettingsToggle(
                      icon: Icons.health_and_safety,
                      label: 'Health Sync',
                      value: isHealthSyncEnabled,
                      onChanged: (v) async {
                        if (v) {
                          final success = await ref
                              .read(healthControllerProvider.notifier)
                              .requestPermissions();
                          if (success && context.mounted) {
                            await ref
                                .read(healthControllerProvider.notifier)
                                .syncSleepData();
                          }
                        }
                      },
                    ),
                    // Health Sync Status Indicator
                    healthState.when(
                      data: (state) {
                        if (state.todayMindfulMinutes != null) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 56,
                              top: 4,
                              bottom: 8,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${state.todayMindfulMinutes} mindful minutes today',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 8),
                    _SettingsToggle(
                      icon: Icons.analytics_outlined,
                      label: 'Analytics',
                      value: ref
                          .watch(analyticsEnabledProvider)
                          .when(
                            data: (v) => v,
                            loading: () => true,
                            error: (_, _) => true,
                          ),
                      onChanged: (v) async {
                        if (v) {
                          await AnalyticsService().enable();
                        } else {
                          await AnalyticsService().disable();
                        }
                        ref.invalidate(analyticsEnabledProvider);
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // About Section
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Divider(color: AppColors.outlineVariant),
                    SizedBox(height: 20),
                    Text(
                      'MindWeave v1.0.0',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _TextLink('Privacy Policy'),
                        SizedBox(width: 16),
                        _TextLink('Terms'),
                        SizedBox(width: 16),
                        _TextLink('Licenses'),
                      ],
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<HealthState> healthState,
    bool isDarkMode,
    bool isHealthSyncEnabled,
  ) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Top Navigation Bar
          _buildDesktopTopNav(context, ref),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(51),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Support MindWeave',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                          fontFamily: 'Space Grotesk',
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Help us keep the sanctuary free for everyone. Your contribution supports development, new frequencies, and mental wellness research.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Funding Progress Card
                      _buildFundingProgressCard(),
                      const SizedBox(height: 32),
                      // Contribution Tiers
                      const Row(
                        children: [
                          Expanded(
                            child: _DesktopTierCard(
                              title: 'Supporter',
                              price: '\$5',
                              period: '/month',
                              icon: Icons.coffee,
                              benefits: [
                                'Exclusive badge',
                                'Early access to new frequencies',
                                'Thank you on our website',
                              ],
                              isPopular: false,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _DesktopTierCard(
                              title: 'Mindweaver',
                              price: '\$15',
                              period: '/month',
                              icon: Icons.star,
                              benefits: [
                                'Everything from Supporter',
                                'Custom preset creation',
                                'Discord community access',
                                'Monthly wellness report',
                              ],
                              isPopular: true,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _DesktopTierCard(
                              title: 'Guardian',
                              price: '\$50',
                              period: '/month',
                              icon: Icons.diamond,
                              benefits: [
                                'Everything from Mindweaver',
                                '1-on-1 wellness consultation',
                                'Name in app credits',
                                'Beta access to new features',
                              ],
                              isPopular: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // One-time Support
                      _buildOneTimeSupport(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTopNav(BuildContext context, WidgetRef ref) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha(102),
        border: Border(
          bottom: BorderSide(color: AppColors.outlineVariant.withAlpha(26)),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'MindWeave',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: AppColors.primary,
              fontFamily: 'Space Grotesk',
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.onSurfaceVariant,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.primary),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.outlineVariant.withAlpha(77)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop&crop=face',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Alex',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundingProgressCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withAlpha(153),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(77)),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Funding Goal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Help us reach our target to keep the lights on',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$3,247',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  Text(
                    'of \$5,000 goal',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.65,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '65% funded',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                '42 supporters',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOneTimeSupport() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withAlpha(102),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'One-time Support',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
              fontFamily: 'Space Grotesk',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Prefer a single contribution? Every bit helps!',
            style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _OneTimeButton(amount: '\$10'),
              SizedBox(width: 12),
              _OneTimeButton(amount: '\$25'),
              SizedBox(width: 12),
              _OneTimeButton(amount: '\$50', isSelected: true),
              SizedBox(width: 12),
              _OneTimeButton(amount: '\$100'),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceContainerHigh,
              foregroundColor: AppColors.onSurface,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Custom Amount'),
          ),
        ],
      ),
    );
  }
}

class _DonationChip extends StatelessWidget {
  final String amount;
  final bool isSelected;
  final VoidCallback onTap;

  const _DonationChip({
    required this.amount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Text(
          amount,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final IconData icon;
  final List<String> benefits;
  final List<Color> gradientColors;

  const _TierCard({
    required this.title,
    required this.price,
    required this.period,
    required this.icon,
    required this.benefits,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withAlpha(128),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                period,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...benefits.map(
            (benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.check,
                    size: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    benefit,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _LinkButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant.withAlpha(77)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withAlpha(77),
            inactiveThumbColor: AppColors.onSurfaceVariant,
            inactiveTrackColor: AppColors.surfaceContainerHigh,
          ),
        ],
      ),
    );
  }
}

class _TextLink extends StatelessWidget {
  final String text;

  const _TextLink(this.text);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
      ),
    );
  }
}

class _DesktopTierCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final IconData icon;
  final List<String> benefits;
  final bool isPopular;

  const _DesktopTierCard({
    required this.title,
    required this.price,
    required this.period,
    required this.icon,
    required this.benefits,
    required this.isPopular,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isPopular
            ? AppColors.primary.withAlpha(26)
            : AppColors.surfaceContainer.withAlpha(102),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular
              ? AppColors.primary.withAlpha(128)
              : AppColors.outlineVariant.withAlpha(51),
          width: isPopular ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'POPULAR',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isPopular
                  ? AppColors.primary.withAlpha(51)
                  : AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isPopular ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
              fontFamily: 'Space Grotesk',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isPopular ? AppColors.primary : AppColors.onSurface,
                  fontFamily: 'Space Grotesk',
                ),
              ),
              Text(
                period,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...benefits.map(
            (benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check,
                    size: 16,
                    color: isPopular
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      benefit,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isPopular
                    ? AppColors.primary
                    : AppColors.surfaceContainerHigh,
                foregroundColor: isPopular
                    ? AppColors.onPrimary
                    : AppColors.onSurface,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(isPopular ? 'Choose $title' : 'Choose $title'),
            ),
          ),
        ],
      ),
    );
  }
}

class _OneTimeButton extends StatelessWidget {
  final String amount;
  final bool isSelected;

  const _OneTimeButton({required this.amount, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withAlpha(51)
            : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withAlpha(128)
              : Colors.transparent,
        ),
      ),
      child: Text(
        amount,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : AppColors.onSurface,
        ),
      ),
    );
  }
}

// Provider for donation progress (mock)
final donationProgressProvider = Provider<double>((ref) => 0.6);
