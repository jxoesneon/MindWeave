import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/deep_link_service.dart';
import '../../core/audio/audio_controller.dart';
import '../../core/audio/audio_state.dart';
import '../../core/audio/mixer_controller.dart';
import '../../core/templates/templates.dart';
import '../../core/organisms/organisms.dart';
import '../../core/molecules/molecules.dart';
import '../../core/atoms/atoms.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';
import '../../core/tokens/shadow_tokens.dart';
import '../../core/tokens/animation_tokens.dart';
import '../../core/models/brainwave_preset.dart';
import '../navigation/app_routes.dart';

/// Desktop Frequency Visualizer with Ethereal Aura Rings
/// Matches Stitch design: 21_desktop_player_dashboard.png
///
/// Rings emanate outward from the central dial when playing,
/// expanding and fading like ripples in a pond.
class _DesktopFrequencyVisualizer extends StatelessWidget {
  final bool isPlaying;
  final Color accentColor;
  final double frequency;
  final Duration? remainingTime;

  static const double _dialSize = 320;
  static const double _maxRingSize = 500;

  const _DesktopFrequencyVisualizer({
    required this.isPlaying,
    required this.accentColor,
    required this.frequency,
    this.remainingTime,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _maxRingSize,
      height: _maxRingSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ethereal aura rings – staggered so 3 are always visible
          if (isPlaying) ...[
            _EtherealRing(
              color: accentColor,
              dialSize: _dialSize,
              maxSize: _maxRingSize,
              delay: 0,
            ),
            _EtherealRing(
              color: accentColor,
              dialSize: _dialSize,
              maxSize: _maxRingSize,
              delay: 1200,
            ),
            _EtherealRing(
              color: accentColor,
              dialSize: _dialSize,
              maxSize: _maxRingSize,
              delay: 2400,
            ),
          ],
          // Main circular dial with optional timer
          FrequencyDial(
            frequency: frequency,
            accentColor: accentColor,
            isPlaying: isPlaying,
            size: _dialSize,
            remainingTime: remainingTime,
          ),
        ],
      ),
    );
  }
}

/// A single ethereal ring that grows outward from the dial edge and fades out.
class _EtherealRing extends StatefulWidget {
  final Color color;
  final double dialSize;
  final double maxSize;
  final int delay;

  const _EtherealRing({
    required this.color,
    required this.dialSize,
    required this.maxSize,
    required this.delay,
  });

  @override
  State<_EtherealRing> createState() => _EtherealRingState();
}

class _EtherealRingState extends State<_EtherealRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Ring grows from dialSize to maxSize
        final size =
            widget.dialSize +
            (widget.maxSize - widget.dialSize) * _controller.value;
        // Opacity peaks early then fades to zero
        final opacity = (1.0 - _controller.value) * 0.6;
        // Border thins as it expands
        final borderWidth = 2.0 * (1.0 - _controller.value) + 0.5;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.color.withAlpha((255 * opacity).toInt()),
              width: borderWidth,
            ),
          ),
        );
      },
    );
  }
}

/// Refactored Player Screen using Atomic Design System
///
/// Provides the main meditation/binaural beats player interface
/// with visualizer, controls, and mixer - for both mobile and desktop.
class PlayerScreen extends ConsumerWidget {
  final DeepLinkService? deepLinkService;

  const PlayerScreen({super.key, this.deepLinkService});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioControllerProvider);
    final mixerState = ref.watch(mixerControllerProvider);

    final accentColor = Color(
      audioState.selectedPreset?.accentColorValue ??
          AppColors.primary.toARGB32(),
    );

    // Check for desktop layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    // Build visualizer - use circular dial for desktop, bars for mobile
    final visualizer = isDesktop
        ? _DesktopFrequencyVisualizer(
            isPlaying: audioState.isPlaying,
            accentColor: accentColor,
            frequency: audioState.beatFrequency,
          )
        : PlayerVisualizer(
            isPlaying: audioState.isPlaying,
            primaryColor: accentColor,
            intensity: 0.7,
          );

    // Build controls
    final controls = PlayerControlBar(
      isPlaying: audioState.isPlaying,
      progress:
          audioState.remainingTime != null && audioState.timerDuration != null
          ? 1 -
                (audioState.remainingTime!.inSeconds /
                    audioState.timerDuration!.inSeconds)
          : 0.0,
      onPlayPause: () =>
          ref.read(audioControllerProvider.notifier).togglePlay(),
      volume: audioState.volume,
      onVolumeChanged: (value) =>
          ref.read(audioControllerProvider.notifier).updateVolume(value),
    );

    // Build mixer panel for side panel (desktop) or bottom sheet (mobile)
    final mixerPanel = MixerPanel(
      carrierFrequency: audioState.carrierFrequency,
      beatFrequency: audioState.beatFrequency,
      noiseLevel: mixerState.backgroundVolume,
      onCarrierChanged: (value) =>
          ref.read(audioControllerProvider.notifier).updateCarrierFreq(value),
      onBeatChanged: (value) =>
          ref.read(audioControllerProvider.notifier).updateBeatFrequency(value),
      onNoiseChanged: (value) => ref
          .read(mixerControllerProvider.notifier)
          .updateBackgroundVolume(value),
    );

    // Build preset info card
    final presetInfo = _PresetInfoCard(
      presetName: audioState.selectedPreset?.name ?? 'Select Preset',
      band: audioState.selectedPreset?.band ?? BrainwaveBand.theta,
      frequency: audioState.beatFrequency,
      onTap: () => _showPresetPicker(context, ref),
    );

    if (isDesktop) {
      return _buildDesktopSanctuary(
        context,
        ref,
        audioState,
        accentColor,
        controls,
      );
    } else {
      return PlayerMobileTemplate(
        visualizer: visualizer,
        presetInfo: presetInfo,
        controls: controls,
        additionalContent: [mixerPanel],
      );
    }
  }

  /// Full desktop Sanctuary layout matching Stitch 21_desktop_player_dashboard.png
  ///
  /// Layout: CurrentStateHeader → FrequencyDial with aura rings → Transport controls
  /// Right panel: Environment grid, Frequency chips, Favorite Nodes, CTA
  /// Bottom: Status bar with carrier freq and signal status
  Widget _buildDesktopSanctuary(
    BuildContext context,
    WidgetRef ref,
    AudioState audioState,
    Color accentColor,
    Widget controls,
  ) {
    final presetName = audioState.selectedPreset?.name ?? 'Deep Theta Flow';
    final band = audioState.selectedPreset?.band ?? BrainwaveBand.theta;
    final description = band.description;

    return Scaffold(
      body: Column(
        children: [
          // Top navigation bar
          DesktopTopBar(
            currentSection: 'Sanctuary',
            onSectionChanged: (section) {
              switch (section) {
                case 'Library':
                  Navigator.pushNamed(context, AppRoutes.favoriteNodes);
                case 'Community':
                  break; // already a main tab
              }
            },
            onProfileTap: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
            onSettingsTap: () {
              Navigator.pushNamed(context, AppRoutes.supportUs);
            },
          ),
          // Main content area
          Expanded(
            child: Row(
              children: [
                // Center: State header + Visualizer + Controls + Bottom status
                Expanded(
                  child: Column(
                    children: [
                      // Main content above status bar
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpacingTokens.xxl,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: SpacingTokens.lg),
                              // Current state header
                              CurrentStateHeader(
                                stateName: presetName,
                                description:
                                    'Synchronizing neural pathways for $description',
                              ),
                              // Frequency dial with aura rings
                              Expanded(
                                child: Center(
                                  child: _DesktopFrequencyVisualizer(
                                    isPlaying: audioState.isPlaying,
                                    accentColor: accentColor,
                                    frequency: audioState.beatFrequency,
                                    remainingTime: audioState.remainingTime,
                                  ),
                                ),
                              ),
                              // Transport controls
                              SizedBox(
                                height: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MwIconButton(
                                      onPressed: () => ref
                                          .read(
                                            audioControllerProvider.notifier,
                                          )
                                          .previousPreset(),
                                      icon: Icons.skip_previous,
                                      size: 32,
                                    ),
                                    const SizedBox(width: SpacingTokens.lg),
                                    _DesktopPlayButton(
                                      isPlaying: audioState.isPlaying,
                                      onPressed: () => ref
                                          .read(
                                            audioControllerProvider.notifier,
                                          )
                                          .togglePlay(),
                                    ),
                                    const SizedBox(width: SpacingTokens.lg),
                                    MwIconButton(
                                      onPressed: () => ref
                                          .read(
                                            audioControllerProvider.notifier,
                                          )
                                          .nextPreset(),
                                      icon: Icons.skip_next,
                                      size: 32,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: SpacingTokens.md),
                            ],
                          ),
                        ),
                      ),
                      // Bottom glass status bar - only under center content
                      BottomStatusBar(
                        carrierFrequency: audioState.carrierFrequency,
                        isSynchronized: audioState.isPlaying,
                        onSettingsTap: () =>
                            Navigator.pushNamed(context, AppRoutes.supportUs),
                      ),
                    ],
                  ),
                ),
                // Right panel: Environment, Frequencies, Favorite Nodes
                Container(
                  width: 340,
                  padding: const EdgeInsets.all(SpacingTokens.lg),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(20),
                    border: Border(
                      left: BorderSide(
                        color: AppColors.outlineVariant.withAlpha(38),
                        width: 1,
                      ),
                    ),
                  ),
                  child: DesktopSanctuaryPanel(
                    selectedBand: band,
                    onBandChanged: (newBand) {
                      // TODO: wire to audio controller
                    },
                    onEnvironmentChanged: (env) {
                      // TODO: wire to mixer controller
                    },
                    onViewAllNodes: () =>
                        Navigator.pushNamed(context, AppRoutes.favoriteNodes),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPresetPicker(BuildContext context, WidgetRef ref) {
    // Show preset picker bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _PresetPickerSheet(),
    );
  }
}

/// Preset info card showing current preset and band
class _PresetInfoCard extends StatelessWidget {
  final String presetName;
  final BrainwaveBand band;
  final double frequency;
  final VoidCallback? onTap;

  const _PresetInfoCard({
    required this.presetName,
    required this.band,
    required this.frequency,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(SpacingTokens.lg),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadiusTokens.card,
        ),
        child: Column(
          children: [
            Text(
              presetName,
              style: TypographyTokens.headlineSmall.copyWith(
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpacingTokens.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BandBadge(band: band, frequency: frequency, isActive: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Large gradient play/pause button for desktop transport controls
/// Matches Stitch design circular play button with glow
class _DesktopPlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback? onPressed;

  const _DesktopPlayButton({required this.isPlaying, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: AnimationTokens.fast,
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: ShadowTokens.buttonGlow,
        ),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: AppColors.onPrimary,
          size: 36,
        ),
      ),
    );
  }
}

/// Preset picker bottom sheet
class _PresetPickerSheet extends ConsumerWidget {
  const _PresetPickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This would show a list of presets to select from
    // Simplified for this refactor
    return Container(
      padding: const EdgeInsets.all(SpacingTokens.lg),
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(SpacingTokens.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Preset',
            style: TypographyTokens.titleLarge.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: SpacingTokens.lg),
          // Preset list would go here
          ListItem(
            icon: Icons.waves,
            title: 'Deep Focus (Gamma)',
            subtitle: '40 Hz - Peak concentration',
            onTap: () => Navigator.pop(context),
          ),
          ListItem(
            icon: Icons.nightlight,
            title: 'Deep Sleep (Delta)',
            subtitle: '2 Hz - Restorative sleep',
            onTap: () => Navigator.pop(context),
          ),
          ListItem(
            icon: Icons.self_improvement,
            title: 'Meditation (Theta)',
            subtitle: '6 Hz - Deep meditation',
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
