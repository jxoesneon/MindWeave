import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/brainwave_preset.dart';
import 'favorites_controller.dart';
import '../community/community_presets_controller.dart';
import '../../core/models/user_preset.dart';
import '../../core/audio/audio_controller.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    if (isDesktop) {
      return _buildDesktopLayout(context, ref);
    }

    return _buildMobileLayout(context, ref);
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesControllerProvider);
    final accentColor = Color(
      ref.watch(audioControllerProvider).selectedPreset?.accentColorValue ??
          Colors.deepPurple.toARGB32(),
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D0F).withValues(alpha: 0.8),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(40),
              ),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 12, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TabBar(
                        isScrollable: true,
                        dividerColor: Colors.transparent,
                        indicatorColor: Colors.deepPurple,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white24,
                        labelStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: [
                          Tab(text: 'My Library'),
                          Tab(text: 'Community'),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white54),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildMyLibrary(
                        context,
                        ref,
                        favoritesAsync,
                        accentColor,
                        false,
                      ),
                      _buildCommunity(context, ref, accentColor, false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Top Navigation Bar
          _buildDesktopTopNav(context, ref),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Library',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                              fontFamily: 'Space Grotesk',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Manage your saved frequencies and favorites',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('Create New Preset'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Filter Tabs
                  const Row(
                    children: [
                      _FilterChip(label: 'All', isSelected: true),
                      SizedBox(width: 8),
                      _FilterChip(label: 'Favorites', isSelected: false),
                      SizedBox(width: 8),
                      _FilterChip(label: 'Recent', isSelected: false),
                      SizedBox(width: 8),
                      _FilterChip(label: 'By Band', isSelected: false),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Library Grid
                  Expanded(
                    child: favoritesAsync.when(
                      data: (favorites) {
                        if (favorites.isEmpty) {
                          return _buildEmptyState(context);
                        }
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 24,
                                mainAxisSpacing: 24,
                                childAspectRatio: 1.2,
                              ),
                          itemCount: favorites.length,
                          itemBuilder: (context, index) {
                            final preset = favorites[index];
                            return _LibraryGridCard(
                              preset: preset,
                              onTap: () {
                                ref
                                    .read(favoritesControllerProvider.notifier)
                                    .loadPreset(preset);
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                      error: (e, _) => Center(child: Text('Error: $e')),
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
          const SizedBox(width: 48),
          _NavLink('Sanctuary', false, onTap: () => Navigator.pop(context)),
          const _NavLink('Library', true),
          _NavLink(
            'Frequencies',
            false,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Frequencies coming soon!')),
              );
            },
          ),
          _NavLink(
            'Journals',
            false,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Journals coming soon!')),
              );
            },
          ),
          const Spacer(),
          Container(
            width: 256,
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, size: 18, color: AppColors.onSurfaceVariant),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search presets, favorites...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(fontSize: 13, color: AppColors.onSurface),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.onSurfaceVariant,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
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
          ),
        ],
      ),
    );
  }

  Widget _buildMyLibrary(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<UserPreset>> favoritesAsync,
    Color accentColor,
    bool isDesktop,
  ) {
    return favoritesAsync.when(
      data: (favorites) {
        if (favorites.isEmpty) {
          return _buildEmptyState(context);
        }
        if (isDesktop) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.2,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final preset = favorites[index];
              return _LibraryGridCard(
                preset: preset,
                onTap: () {
                  ref
                      .read(favoritesControllerProvider.notifier)
                      .loadPreset(preset);
                  Navigator.pop(context);
                },
              );
            },
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final preset = favorites[index];
            return _FavoriteCard(
              preset: preset,
              accentColor: accentColor,
              onTap: () {
                ref
                    .read(favoritesControllerProvider.notifier)
                    .loadPreset(preset);
                Navigator.pop(context);
              },
              onDelete: () => ref
                  .read(favoritesControllerProvider.notifier)
                  .deleteFavorite(preset.id),
              onTogglePublic: () => ref
                  .read(favoritesControllerProvider.notifier)
                  .togglePublic(preset),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildCommunity(
    BuildContext context,
    WidgetRef ref,
    Color accentColor,
    bool isDesktop,
  ) {
    final communityAsync = ref.watch(communityPresetsControllerProvider);

    return communityAsync.when(
      data: (presets) {
        if (presets.isEmpty) {
          return const Center(
            child: Text('No community presets yet. Be the first to share!'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: presets.length,
          itemBuilder: (context, index) {
            final preset = presets[index];
            return _CommunityCard(
              preset: preset,
              accentColor: accentColor,
              onTap: () {
                ref
                    .read(communityPresetsControllerProvider.notifier)
                    .loadCommunityPreset(preset);
                Navigator.pop(context);
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_music_outlined,
            size: 64,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your library is empty',
            style: TextStyle(color: Colors.white38),
          ),
          const SizedBox(height: 8),
          const Text(
            'Save your current session to see it here.',
            style: TextStyle(color: Colors.white24, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final UserPreset preset;
  final Color accentColor;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onTogglePublic;

  const _FavoriteCard({
    required this.preset,
    required this.accentColor,
    required this.onTap,
    required this.onDelete,
    required this.onTogglePublic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
        title: Row(
          children: [
            Expanded(
              child: Text(
                preset.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: Icon(
                preset.isPublic ? Icons.public : Icons.public_off,
                color: preset.isPublic ? Colors.blueAccent : Colors.white10,
                size: 18,
              ),
              tooltip: preset.isPublic ? 'Public' : 'Private',
              onPressed: onTogglePublic,
            ),
          ],
        ),
        subtitle: Text(
          '${preset.carrierFrequency.toInt()}Hz / ${preset.beatFrequency}Hz • ${preset.noiseType.name}',
          style: const TextStyle(color: Colors.white38, fontSize: 12),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.white24,
            size: 20,
          ),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final UserPreset preset;
  final Color accentColor;
  final VoidCallback onTap;

  const _CommunityCard({
    required this.preset,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.auto_awesome, color: accentColor, size: 20),
        ),
        title: Text(
          preset.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${preset.beatFrequency}Hz ${preset.noiseType.name.toUpperCase()}',
          style: TextStyle(
            color: accentColor.withValues(alpha: 0.5),
            fontSize: 11,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavLink(this.label, this.isActive, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive
                ? AppColors.onSurface
                : AppColors.onSurface.withAlpha(153),
            fontFamily: 'Space Grotesk',
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _LibraryGridCard extends StatelessWidget {
  final UserPreset preset;
  final VoidCallback onTap;

  const _LibraryGridCard({required this.preset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final band = _getBandFromFrequency(preset.beatFrequency);
    final bandColor = _getBandColor(band);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant.withAlpha(51)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: bandColor.withAlpha(51),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.psychology, color: bandColor),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.favorite,
                    color: AppColors.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              preset.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
                fontFamily: 'Space Grotesk',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${band.name} waves for ${band.name.toLowerCase()} states',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(
                  Icons.waves,
                  size: 14,
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '${preset.beatFrequency}Hz',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: bandColor.withAlpha(51),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    band.name,
                    style: TextStyle(fontSize: 12, color: bandColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BrainwaveBand _getBandFromFrequency(double frequency) {
    if (frequency < 4) return BrainwaveBand.delta;
    if (frequency < 8) return BrainwaveBand.theta;
    if (frequency < 13) return BrainwaveBand.alpha;
    if (frequency < 30) return BrainwaveBand.beta;
    return BrainwaveBand.gamma;
  }

  Color _getBandColor(BrainwaveBand band) {
    switch (band) {
      case BrainwaveBand.delta:
        return AppColors.primary;
      case BrainwaveBand.theta:
        return AppColors.secondary;
      case BrainwaveBand.alpha:
        return AppColors.tertiary;
      case BrainwaveBand.beta:
        return AppColors.error;
      case BrainwaveBand.gamma:
        return AppColors.primary;
    }
  }
}
