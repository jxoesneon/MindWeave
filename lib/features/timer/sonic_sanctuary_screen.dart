import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tokens/typography_tokens.dart';
import '../../core/tokens/spacing_tokens.dart';
import '../../core/tokens/border_radius_tokens.dart';
import '../navigation/app_routes.dart';

/// Sonic Sanctuary Timer Screen — matches Stitch design: 35_timer_session_active.png
///
/// Features:
/// - Header with back, notifications, settings, profile
/// - Circular timer with progress indicator
/// - Active frequency display (Deep Delta)
/// - Session controls (Play/Pause, Stop)
/// - Preset duration chips
/// - Dissolution info text
class SonicSanctuaryScreen extends ConsumerStatefulWidget {
  const SonicSanctuaryScreen({super.key});

  @override
  ConsumerState<SonicSanctuaryScreen> createState() =>
      _SonicSanctuaryScreenState();
}

class _SonicSanctuaryScreenState extends ConsumerState<SonicSanctuaryScreen> {
  int _selectedMinutes = 30;
  int _remainingSeconds = 30 * 60;
  bool _isPlaying = false;
  Timer? _timer;
  final TextEditingController _customController = TextEditingController();

  // Audio player for soundscapes
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _selectedSoundscape;
  double _soundscapeVolume = 0.5;

  final List<int> _presetDurations = [5, 15, 30, 45, 60, 90];

  final List<Map<String, String>> _soundscapes = [
    {
      'name': 'Night Forest',
      'file': 'assets/audio/soundscapes/night_forest.wav',
      'icon': '🌲',
    },
    {
      'name': 'Heavy Rain',
      'file': 'assets/audio/soundscapes/heavy_rain.wav',
      'icon': '🌧️',
    },
    {
      'name': 'Desert Wind',
      'file': 'assets/audio/soundscapes/desert_wind.wav',
      'icon': '🏜️',
    },
    {
      'name': 'Ocean Deep',
      'file': 'assets/audio/soundscapes/ocean_deep.wav',
      'icon': '🌊',
    },
    {
      'name': 'Sacred Cave',
      'file': 'assets/audio/soundscapes/sacred_cave.wav',
      'icon': '🪨',
    },
  ];

  @override
  void dispose() {
    _timer?.cancel();
    _customController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadSoundscape(String assetPath) async {
    try {
      await _audioPlayer.setAsset(assetPath);
      await _audioPlayer.setLoopMode(LoopMode.one);
      await _audioPlayer.setVolume(_soundscapeVolume);
    } catch (e) {
      debugPrint('Error loading soundscape: $e');
    }
  }

  Future<void> _playSoundscape() async {
    if (_selectedSoundscape != null) {
      await _loadSoundscape(_selectedSoundscape!);
      await _audioPlayer.play();
    }
  }

  Future<void> _pauseSoundscape() async {
    await _audioPlayer.pause();
  }

  Future<void> _stopSoundscape() async {
    await _audioPlayer.stop();
  }

  void _selectSoundscape(Map<String, String> soundscape) {
    setState(() {
      _selectedSoundscape = soundscape['file'];
    });
    if (_isPlaying) {
      _playSoundscape();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        setState(() => _isPlaying = false);
        _onTimerComplete();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _onTimerComplete() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session complete. Your mind has woven its silence.'),
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        if (_remainingSeconds == 0) {
          _remainingSeconds = _selectedMinutes * 60;
        }
        _startTimer();
        _playSoundscape();
      } else {
        _stopTimer();
        _pauseSoundscape();
      }
    });
  }

  void _stopSession() {
    _stopTimer();
    _stopSoundscape();
    setState(() {
      _isPlaying = false;
      _remainingSeconds = _selectedMinutes * 60;
    });
  }

  void _updateDuration(int minutes) {
    _stopTimer();
    setState(() {
      _selectedMinutes = minutes;
      _remainingSeconds = minutes * 60;
      _isPlaying = false;
    });
  }

  String get _timeDisplay {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get _progress => _remainingSeconds / (_selectedMinutes * 60);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final hPad = isDesktop ? SpacingTokens.xxl : SpacingTokens.lg;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with search bar and action buttons inline
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  hPad,
                  SpacingTokens.lg,
                  hPad,
                  SpacingTokens.lg,
                ),
                child: Row(
                  children: [
                    // Back button with fixed width container to balance right side
                    SizedBox(
                      width: 140,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Search bar (20% width, centered)
                    Flexible(
                      flex: 2,
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadiusTokens.fullCircular,
                          border: Border.all(
                            color: AppColors.outlineVariant.withAlpha(51),
                          ),
                        ),
                        child: TextField(
                          style: TypographyTokens.bodyMedium.copyWith(
                            color: AppColors.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search sessions...',
                            hintStyle: TypographyTokens.bodyMedium.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.onSurfaceVariant,
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: SpacingTokens.md,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Action buttons with fixed width container
                    SizedBox(
                      width: 140,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              AppRoutes.notifications,
                            ),
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              AppRoutes.supportUs,
                            ),
                            icon: const Icon(
                              Icons.settings_outlined,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, AppRoutes.profile),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Title
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  hPad,
                  SpacingTokens.xl,
                  hPad,
                  SpacingTokens.lg,
                ),
                child: Column(
                  children: [
                    Text(
                      'Sonic Sanctuary',
                      style: TypographyTokens.headlineLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: SpacingTokens.sm),
                    Text(
                      'Set your dissolution threshold. Your mind weaves its own\nsilence as the frequencies fade.',
                      textAlign: TextAlign.center,
                      style: TypographyTokens.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main content
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildTimerSection()),
                          const SizedBox(width: SpacingTokens.xxl),
                          Expanded(child: _buildControlsSection()),
                        ],
                      )
                    : Column(
                        children: [
                          _buildTimerSection(),
                          const SizedBox(height: SpacingTokens.xl),
                          _buildControlsSection(),
                        ],
                      ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: SpacingTokens.xxl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerSection() {
    return Column(
      children: [
        // Circular timer with progress
        Stack(
          alignment: Alignment.center,
          children: [
            // Progress ring
            SizedBox(
              width: 260,
              height: 260,
              child: CircularProgressIndicator(
                value: _progress,
                strokeWidth: 4,
                backgroundColor: AppColors.surfaceContainerHigh,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            // Timer container
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceContainerLow,
                border: Border.all(
                  color: AppColors.primary.withAlpha(64),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(26),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _timeDisplay,
                      style: TypographyTokens.timeDisplay.copyWith(
                        color: AppColors.onSurface,
                        fontSize: 56,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'REMAINING',
                      style: TypographyTokens.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.5,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: SpacingTokens.xl),

        // Session controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Stop button
            _ControlButton(
              icon: Icons.stop,
              onTap: _stopSession,
              color: AppColors.error,
            ),
            const SizedBox(width: SpacingTokens.lg),
            // Play/Pause button (larger)
            GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryContainer],
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
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: AppColors.onPrimary,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(width: SpacingTokens.lg),
            // Reset button
            _ControlButton(
              icon: Icons.refresh,
              onTap: () => _updateDuration(_selectedMinutes),
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
        const SizedBox(height: SpacingTokens.lg),

        // Active frequency info
        Container(
          padding: const EdgeInsets.all(SpacingTokens.lg),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadiusTokens.card,
            border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Frequency',
                    style: TypographyTokens.labelMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpacingTokens.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(26),
                      borderRadius: BorderRadiusTokens.smCircular,
                    ),
                    child: Text(
                      'DEEP DELTA',
                      style: TypographyTokens.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SpacingTokens.md),
              Text(
                'The soundscape will gradually decrease in volume over the final 5 minutes of your chosen duration.',
                style: TypographyTokens.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preset Durations
        Row(
          children: [
            const Icon(Icons.timer, size: 18, color: AppColors.primary),
            const SizedBox(width: SpacingTokens.xs),
            Text(
              'Preset Durations',
              style: TypographyTokens.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: SpacingTokens.md),

        // Duration chips — 3x2 grid
        Wrap(
          spacing: SpacingTokens.sm,
          runSpacing: SpacingTokens.sm,
          children: _presetDurations.map((min) {
            final isSelected = min == _selectedMinutes;
            return GestureDetector(
              onTap: () => _updateDuration(min),
              child: Container(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: SpacingTokens.md),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withAlpha(38)
                      : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadiusTokens.mdCircular,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.outlineVariant.withAlpha(38),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '$min',
                      style: TypographyTokens.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.onSurface,
                      ),
                    ),
                    Text(
                      'MIN',
                      style: TypographyTokens.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 9,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: SpacingTokens.xl),

        // Custom Duration
        Row(
          children: [
            const Icon(Icons.edit, size: 18, color: AppColors.primary),
            const SizedBox(width: SpacingTokens.xs),
            Text(
              'Custom Duration',
              style: TypographyTokens.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: SpacingTokens.md),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadiusTokens.mdCircular,
                  border: Border.all(
                    color: AppColors.outlineVariant.withAlpha(38),
                  ),
                ),
                child: TextField(
                  controller: _customController,
                  keyboardType: TextInputType.number,
                  style: TypographyTokens.bodyMedium.copyWith(
                    color: AppColors.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter minutes',
                    hintStyle: TypographyTokens.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    final mins = int.tryParse(value);
                    if (mins != null && mins > 0) {
                      _updateDuration(mins);
                      _customController.clear();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: SpacingTokens.sm),
            Text(
              'MINS',
              style: TypographyTokens.labelMedium.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: SpacingTokens.xl),

        // Soundscape Selection
        Row(
          children: [
            const Icon(Icons.landscape, size: 18, color: AppColors.primary),
            const SizedBox(width: SpacingTokens.xs),
            Text(
              'Environment',
              style: TypographyTokens.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: SpacingTokens.md),

        // Soundscape chips
        Wrap(
          spacing: SpacingTokens.sm,
          runSpacing: SpacingTokens.sm,
          children: _soundscapes.map((soundscape) {
            final isSelected = _selectedSoundscape == soundscape['file'];
            return GestureDetector(
              onTap: () => _selectSoundscape(soundscape),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.md,
                  vertical: SpacingTokens.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withAlpha(38)
                      : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadiusTokens.mdCircular,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.outlineVariant.withAlpha(38),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      soundscape['icon']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: SpacingTokens.xs),
                    Text(
                      soundscape['name']!,
                      style: TypographyTokens.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: SpacingTokens.xl),

        // Disable Timer button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.timer_off, size: 18),
            label: const Text('Disable Timer'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onSurfaceVariant,
              side: BorderSide(color: AppColors.outlineVariant.withAlpha(77)),
              padding: const EdgeInsets.symmetric(vertical: SpacingTokens.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusTokens.mdCircular,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surfaceContainerLow,
          border: Border.all(color: AppColors.outlineVariant.withAlpha(38)),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
