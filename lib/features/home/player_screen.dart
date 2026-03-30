import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/monetization/monetization_controller.dart';
import '../../core/audio/audio_controller.dart';
import '../../core/audio/audio_state.dart';
import '../../core/audio/mixer_controller.dart';
import '../../core/audio/mixer_state.dart';
import '../../core/models/brainwave_preset.dart';
import '../../core/models/presets_provider.dart';
import '../../features/favorites/favorites_controller.dart';
import '../../features/favorites/library_screen.dart';
import '../../features/health/health_controller.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/streaks/streak_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui';

import '../../core/session/user_session_controller.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userSessionControllerProvider);

    final audioState = ref.watch(audioControllerProvider);
    final mixerState = ref.watch(mixerControllerProvider);
    final presetsAsync = ref.watch(presetsProvider);
    final isEligibleForDonation = ref.watch(monetizationControllerProvider);

    final accentColor = Color(
      audioState.selectedPreset?.accentColorValue ??
          AppColors.primary.toARGB32(),
    );

    // Check for desktop layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    if (isDesktop) {
      return _buildDesktopLayout(
        context,
        ref,
        audioState,
        mixerState,
        presetsAsync,
        isEligibleForDonation,
        accentColor,
      );
    }

    return _buildMobileLayout(
      context,
      ref,
      audioState,
      mixerState,
      presetsAsync,
      isEligibleForDonation,
      accentColor,
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    AudioState audioState,
    MixerState mixerState,
    AsyncValue<List<BrainwavePreset>> presetsAsync,
    bool isEligibleForDonation,
    Color accentColor,
  ) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background with subtle gradient
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.background, accentColor.withAlpha(20)],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header with Streak Badge
                _buildHeader(context, ref, accentColor),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Frequency Visualizer
                        _FrequencyVisualizer(
                          isPlaying: audioState.isPlaying,
                          accentColor: accentColor,
                          remainingTime: audioState.remainingTime,
                        ),

                        const SizedBox(height: 24),

                        // Preset Info
                        if (audioState.selectedPreset != null) ...[
                          Text(
                            audioState.selectedPreset!.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${audioState.selectedPreset!.band.name} - ${audioState.selectedPreset!.band.description}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Playback Controls
                        _PlaybackControls(
                          isPlaying: audioState.isPlaying,
                          accentColor: accentColor,
                          onToggle: () => ref
                              .read(audioControllerProvider.notifier)
                              .togglePlay(),
                          onFavorite: () => _showSavePresetDialog(context, ref),
                        ),

                        const SizedBox(height: 32),

                        // Controls Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              // Carrier Frequency Slider
                              _ControlSlider(
                                label: 'Carrier Frequency',
                                value: audioState.carrierFrequency,
                                min: 100,
                                max: 400,
                                suffix: 'Hz',
                                accentColor: accentColor,
                                onChanged: (value) => ref
                                    .read(audioControllerProvider.notifier)
                                    .updateCarrierFreq(value),
                              ),

                              const SizedBox(height: 24),

                              // Background Noise Mixer
                              _NoiseMixer(
                                currentType: mixerState.noiseType,
                                volume: mixerState.backgroundVolume,
                                accentColor: accentColor,
                                onTypeChanged: (type) => ref
                                    .read(mixerControllerProvider.notifier)
                                    .setNoiseType(type),
                                onVolumeChanged: (volume) => ref
                                    .read(mixerControllerProvider.notifier)
                                    .updateBackgroundVolume(volume),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Preset Selector
                        _buildPresetSelector(presetsAsync, audioState, ref),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Donation Banner
          if (isEligibleForDonation) _DonationBanner(accentColor: accentColor),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    WidgetRef ref,
    AudioState audioState,
    MixerState mixerState,
    AsyncValue<List<BrainwavePreset>> presetsAsync,
    bool isEligibleForDonation,
    Color accentColor,
  ) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Top Navigation Bar
          _buildDesktopTopNav(context, ref),
          // Main Content
          Expanded(
            child: Row(
              children: [
                // Left Sidebar: Frequency Presets
                _buildDesktopLeftSidebar(presetsAsync, audioState, ref),
                // Center: Main Player
                _buildDesktopCenterPlayer(
                  audioState,
                  mixerState,
                  ref,
                  accentColor,
                ),
                // Right Sidebar: Controls & Mixer
                _buildDesktopRightSidebar(
                  audioState,
                  mixerState,
                  ref,
                  accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Streak
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withAlpha(51),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MindWeave',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                      letterSpacing: -0.3,
                    ),
                  ),
                  StreakBadge(),
                ],
              ),
            ],
          ),

          // Action Icons
          Row(
            children: [
              _IconButton(
                icon: Icons.share_outlined,
                onPressed: () => _handleShare(context, ref),
              ),
              _IconButton(
                icon: Icons.health_and_safety_outlined,
                onPressed: () => _showHealthSync(context, ref),
              ),
              _IconButton(
                icon: Icons.library_music_outlined,
                onPressed: () => _showLibrary(context),
              ),
              _IconButton(
                icon: Icons.timer_outlined,
                onPressed: () => _showTimerPicker(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetSelector(
    AsyncValue<List<BrainwavePreset>> presetsAsync,
    AudioState audioState,
    WidgetRef ref,
  ) {
    return SizedBox(
      height: 100,
      child: presetsAsync.when(
        data: (presets) => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: presets.length,
          itemBuilder: (context, index) {
            final preset = presets[index];
            final isSelected = audioState.selectedPreset?.id == preset.id;
            return _PresetCard(
              preset: preset,
              isSelected: isSelected,
              onTap: () => ref
                  .read(audioControllerProvider.notifier)
                  .selectPreset(preset),
            );
          },
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => const Center(
          child: Text(
            'Error loading presets',
            style: TextStyle(color: AppColors.onSurfaceVariant),
          ),
        ),
      ),
    );
  }

  void _showTimerPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TimerPickerSheet(),
    );
  }

  void _handleShare(BuildContext context, WidgetRef ref) {
    final state = ref.read(audioControllerProvider);
    final mixer = ref.read(mixerControllerProvider);

    final name = state.selectedPreset?.name ?? 'Custom Session';
    final carrier = state.carrierFrequency.toStringAsFixed(0);
    final beat = state.beatFrequency.toStringAsFixed(1);
    final noise = mixer.noiseType.name;

    final shareText =
        '''
🧘 My MindWeave Session: $name
- Carrier: ${carrier}Hz
- Beat: ${beat}Hz (${state.selectedPreset?.band.name ?? 'Custom'})
- Background: $noise

Listen at: mindweave://share?c=$carrier&b=$beat&n=$noise
''';

    Share.share(shareText, subject: 'MindWeave Preset');
  }

  void _showHealthSync(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Sleep Sync',
          style: TextStyle(color: AppColors.onSurface),
        ),
        content: const Text(
          'Sync your last 24h of sleep data to optimize your meditation sessions.',
          style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(healthControllerProvider.notifier).syncSleepData();
            },
            child: const Text(
              'Sync Now',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showLibrary(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LibraryScreen(),
    );
  }

  void _showSavePresetDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Save Favorite',
          style: TextStyle(color: AppColors.onSurface),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Preset Name (e.g. Deep Work)',
            hintStyle: TextStyle(color: AppColors.onSurfaceVariant),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.outlineVariant),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          style: const TextStyle(color: AppColors.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref
                    .read(favoritesControllerProvider.notifier)
                    .saveCurrentPreset(controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Saved "${controller.text}" to Library'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  // Desktop layout helper methods
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
          _DesktopNavLink(
            'Library',
            false,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LibraryScreen()),
            ),
          ),
          const _DesktopNavLink('Sanctuary', true),
          _DesktopNavLink(
            'Frequencies',
            false,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Frequencies coming soon!')),
              );
            },
          ),
          _DesktopNavLink(
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
                      hintText: 'Search frequencies, presets...',
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
          const _DesktopIconButton(icon: Icons.notifications_outlined),
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

  Widget _buildDesktopLeftSidebar(
    AsyncValue<List<BrainwavePreset>> presetsAsync,
    AudioState audioState,
    WidgetRef ref,
  ) {
    return Container(
      width: 288,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer.withAlpha(102),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.outlineVariant.withAlpha(51),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Frequency Presets',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: presetsAsync.when(
                      data: (presets) => ListView.builder(
                        itemCount: presets.length,
                        itemBuilder: (context, index) {
                          final preset = presets[index];
                          final isSelected =
                              audioState.selectedPreset?.id == preset.id;
                          return _DesktopPresetListItem(
                            preset: preset,
                            isSelected: isSelected,
                            onTap: () => ref
                                .read(audioControllerProvider.notifier)
                                .selectPreset(preset),
                          );
                        },
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                      error: (error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer.withAlpha(102),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant.withAlpha(51)),
            ),
            padding: const EdgeInsets.all(20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SESSION STATS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _DesktopStatCard(
                        value: '127',
                        label: 'Sessions',
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _DesktopStatCard(
                        value: '42h',
                        label: 'Total Time',
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopCenterPlayer(
    AudioState audioState,
    MixerState mixerState,
    WidgetRef ref,
    Color accentColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                height: 400,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 500,
                      height: 500,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withAlpha(13),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.secondary.withAlpha(26),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: accentColor.withAlpha(51),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withAlpha(20),
                            blurRadius: 60,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(60),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surfaceContainerHigh.withAlpha(128),
                          border: Border.all(
                            color: AppColors.outlineVariant.withAlpha(77),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.psychology,
                              size: 64,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${audioState.beatFrequency.toStringAsFixed(1)}Hz',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                                fontFamily: 'Space Grotesk',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${audioState.selectedPreset?.band.name ?? 'Theta'} Wave',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.onSurfaceVariant,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _DesktopControlButton(
                    icon: Icons.skip_previous,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 24),
                  _DesktopPlayButton(
                    isPlaying: audioState.isPlaying,
                    onPressed: () =>
                        ref.read(audioControllerProvider.notifier).togglePlay(),
                  ),
                  const SizedBox(width: 24),
                  _DesktopControlButton(
                    icon: Icons.skip_next,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow.withAlpha(128),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.outlineVariant.withAlpha(51),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 18,
                      color: AppColors.onSurfaceVariant,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Session Time:',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '14:32',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'monospace',
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopRightSidebar(
    AudioState audioState,
    MixerState mixerState,
    WidgetRef ref,
    Color accentColor,
  ) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer.withAlpha(102),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant.withAlpha(51)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Carrier Frequency',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                        fontFamily: 'Space Grotesk',
                      ),
                    ),
                    Text(
                      '${audioState.carrierFrequency.toInt()}Hz',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 16,
                    ),
                    activeTrackColor: accentColor,
                    inactiveTrackColor: AppColors.surfaceContainerHigh,
                    thumbColor: accentColor,
                    overlayColor: accentColor.withAlpha(26),
                  ),
                  child: Slider(
                    value: audioState.carrierFrequency,
                    min: 100,
                    max: 400,
                    onChanged: (value) => ref
                        .read(audioControllerProvider.notifier)
                        .updateCarrierFreq(value),
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '100Hz',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '400Hz',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer.withAlpha(102),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.outlineVariant.withAlpha(51),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Background Mixer',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                      fontFamily: 'Space Grotesk',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: const [
                        _DesktopMixerItem(
                          icon: Icons.water,
                          title: 'Rain',
                          subtitle: 'Gentle rainfall',
                          value: 0.3,
                          isActive: false,
                        ),
                        _DesktopMixerItem(
                          icon: Icons.forest,
                          title: 'Forest',
                          subtitle: 'Birds & rustling',
                          value: 0.45,
                          isActive: true,
                        ),
                        _DesktopMixerItem(
                          icon: Icons.waves,
                          title: 'Ocean',
                          subtitle: 'Waves crashing',
                          value: 0,
                          isActive: false,
                        ),
                        _DesktopMixerItem(
                          icon: Icons.air,
                          title: 'Wind',
                          subtitle: 'Soft breeze',
                          value: 0,
                          isActive: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer.withAlpha(102),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outlineVariant.withAlpha(51)),
            ),
            padding: const EdgeInsets.all(20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sleep Timer',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                    fontFamily: 'Space Grotesk',
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    _DesktopTimerChip(label: '15m', isSelected: false),
                    SizedBox(width: 8),
                    _DesktopTimerChip(label: '30m', isSelected: false),
                    SizedBox(width: 8),
                    _DesktopTimerChip(label: '45m', isSelected: false),
                    SizedBox(width: 8),
                    _DesktopTimerChip(label: '60m', isSelected: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _IconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: AppColors.onSurfaceVariant, size: 22),
      onPressed: onPressed,
      splashRadius: 24,
    );
  }
}

class _FrequencyVisualizer extends StatelessWidget {
  final bool isPlaying;
  final Color accentColor;
  final Duration? remainingTime;

  const _FrequencyVisualizer({
    required this.isPlaying,
    required this.accentColor,
    this.remainingTime,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated aura rings
          if (isPlaying) ...[
            _AuraRing(color: accentColor, size: 280, delay: 0),
            _AuraRing(color: accentColor, size: 240, delay: 300),
            _AuraRing(color: accentColor, size: 200, delay: 600),
          ],

          // Main circle background
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: accentColor.withAlpha(77), width: 2),
              gradient: RadialGradient(
                colors: [accentColor.withAlpha(26), Colors.transparent],
              ),
              boxShadow: [
                if (isPlaying)
                  BoxShadow(
                    color: accentColor.withAlpha(51),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
              ],
            ),
          ),

          // Center icon
          Icon(
            Icons.waves,
            size: 80,
            color: isPlaying ? accentColor : AppColors.onSurface.withAlpha(51),
          ),

          // Timer display
          if (remainingTime != null)
            Positioned(
              bottom: 40,
              child: Text(
                _formatDuration(remainingTime!),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: AppColors.onSurface,
                  letterSpacing: 2,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _AuraRing extends StatelessWidget {
  final Color color;
  final double size;
  final int delay;

  const _AuraRing({
    required this.color,
    required this.size,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: size * value,
          height: size * value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withAlpha((51 - (delay / 2000) * 255).toInt()),
              width: 1,
            ),
          ),
        );
      },
    );
  }
}

class _PlaybackControls extends StatelessWidget {
  final bool isPlaying;
  final Color accentColor;
  final VoidCallback onToggle;
  final VoidCallback onFavorite;

  const _PlaybackControls({
    required this.isPlaying,
    required this.accentColor,
    required this.onToggle,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Favorite button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onFavorite,
            borderRadius: BorderRadius.circular(28),
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceContainerHigh,
              ),
              child: const Icon(
                Icons.favorite_border,
                color: AppColors.onSurfaceVariant,
                size: 24,
              ),
            ),
          ),
        ),

        const SizedBox(width: 24),

        // Play/Pause button
        GestureDetector(
          onTap: onToggle,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withAlpha(26),
              border: Border.all(color: accentColor.withAlpha(77), width: 2),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withAlpha(51),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 40,
              color: accentColor,
            ),
          ),
        ),

        const SizedBox(width: 24),

        // Spacer for balance
        const SizedBox(width: 56),
      ],
    );
  }
}

class _ControlSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String suffix;
  final Color accentColor;
  final ValueChanged<double> onChanged;

  const _ControlSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.accentColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'label',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
            ),
            Text(
              '${value.toInt()}$suffix',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: accentColor,
            inactiveTrackColor: AppColors.surfaceContainerHigh,
            thumbColor: accentColor,
            overlayColor: accentColor.withAlpha(26),
          ),
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),
      ],
    );
  }
}

class _NoiseMixer extends StatelessWidget {
  final NoiseType currentType;
  final double volume;
  final Color accentColor;
  final ValueChanged<NoiseType> onTypeChanged;
  final ValueChanged<double> onVolumeChanged;

  const _NoiseMixer({
    required this.currentType,
    required this.volume,
    required this.accentColor,
    required this.onTypeChanged,
    required this.onVolumeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Background Noise',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: NoiseType.values.map((type) {
                    final isSelected = currentType == type;
                    return GestureDetector(
                      onTap: () => onTypeChanged(type),
                      child: Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? accentColor.withAlpha(51)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? accentColor
                                : AppColors.outlineVariant,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          type.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? accentColor
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            activeTrackColor: AppColors.onSurfaceVariant,
            inactiveTrackColor: AppColors.surfaceContainerHigh,
            thumbColor: AppColors.onSurface,
          ),
          child: Slider(value: volume, onChanged: onVolumeChanged),
        ),
      ],
    );
  }
}

class _PresetCard extends StatelessWidget {
  final BrainwavePreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetCard({
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  Color get bandColor {
    switch (preset.band) {
      case BrainwaveBand.delta:
        return AppColors.delta;
      case BrainwaveBand.theta:
        return AppColors.theta;
      case BrainwaveBand.alpha:
        return AppColors.alpha;
      case BrainwaveBand.beta:
        return AppColors.beta;
      case BrainwaveBand.gamma:
        return AppColors.gamma;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        width: 80,
        height: 96,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : bandColor.withAlpha(77),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              preset.name.split(' ').first,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppColors.onPrimary
                    : AppColors.onSurface.withAlpha(204),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${preset.beatFrequency.toStringAsFixed(0)}Hz',
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? AppColors.onPrimary.withAlpha(179)
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DonationBanner extends StatelessWidget {
  final Color accentColor;

  const _DonationBanner({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer.withAlpha(153),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.outlineVariant.withAlpha(77)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enjoying the weave?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Support MindWeave and help us build better tools for mental clarity.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.onSurface,
                    foregroundColor: AppColors.background,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Become a Mindweaver',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimerPickerSheet extends ConsumerWidget {
  const TimerPickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presetTimes = [5, 15, 30, 45, 60, 90];
    final customController = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withAlpha(242),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant.withAlpha(77)),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.onSurfaceVariant.withAlpha(77),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Header
              const Text(
                'Set Sleep Timer',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Audio will fade out gradually',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              // Preset chips
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: presetTimes.map((mins) {
                  return _TimeChip(
                    label: '$mins min',
                    isSelected: false,
                    onTap: () {
                      ref
                          .read(audioControllerProvider.notifier)
                          .setTimer(Duration(minutes: mins));
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Custom input
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Or enter custom duration',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: customController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Custom (minutes)',
                        hintStyle: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceContainerLowest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.outlineVariant,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      style: const TextStyle(color: AppColors.onSurface),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      final mins = int.tryParse(customController.text);
                      if (mins != null && mins > 0) {
                        ref
                            .read(audioControllerProvider.notifier)
                            .setTimer(Duration(minutes: mins));
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Footer actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Start Timer',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class StreakBadge extends ConsumerWidget {
  const StreakBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakControllerProvider);

    return streakAsync.when(
      data: (streak) {
        if (streak == 0) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                '$streak Day Streak',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

// Desktop widget classes
class _DesktopNavLink extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _DesktopNavLink(this.label, this.isActive, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive
                ? AppColors.primary
                : AppColors.onSurface.withAlpha(153),
            fontFamily: 'Space Grotesk',
            letterSpacing: -0.3,
          ),
        ),
      ),
    );
  }
}

class _DesktopIconButton extends StatelessWidget {
  final IconData icon;

  const _DesktopIconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: AppColors.onSurfaceVariant),
      onPressed: () {},
    );
  }
}

class _DesktopPresetListItem extends StatelessWidget {
  final BrainwavePreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  const _DesktopPresetListItem({
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  Color get _bandColor {
    switch (preset.band) {
      case BrainwaveBand.delta:
        return AppColors.delta;
      case BrainwaveBand.theta:
        return AppColors.theta;
      case BrainwaveBand.alpha:
        return AppColors.alpha;
      case BrainwaveBand.beta:
        return AppColors.beta;
      case BrainwaveBand.gamma:
        return AppColors.gamma;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(26)
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withAlpha(77)
                : Colors.transparent,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'preset.name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _bandColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'preset.band.name.substring(0, 1).toUpperCase() + preset.band.name.substring(1)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.waves, size: 14, color: AppColors.onSurfaceVariant),
                SizedBox(width: 6),
                Text(
                  'preset.beatFrequency.toStringAsFixed(1)Hz',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _DesktopStatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Space Grotesk',
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _DesktopControlButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.onSurface),
        onPressed: onPressed,
      ),
    );
  }
}

class _DesktopPlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  const _DesktopPlayButton({required this.isPlaying, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(77),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: AppColors.onPrimary,
          size: 32,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class _DesktopMixerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double value;
  final bool isActive;

  const _DesktopMixerItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withAlpha(26)
            : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? AppColors.primary.withAlpha(77)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withAlpha(51)
                  : AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${(value * 100).toInt()}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopTimerChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _DesktopTimerChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withAlpha(51)
            : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withAlpha(77)
              : Colors.transparent,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isSelected ? AppColors.primary : AppColors.onSurface,
        ),
      ),
    );
  }
}
