import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/brainwave_preset.dart';

/// Frequency visualizer widget with animated aura rings
class FrequencyVisualizer extends StatelessWidget {
  final bool isPlaying;
  final Color accentColor;
  final Duration? remainingTime;

  const FrequencyVisualizer({
    super.key,
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
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

/// Animated aura ring for the visualizer
class _AuraRing extends StatefulWidget {
  final Color color;
  final double size;
  final int delay;

  const _AuraRing({
    required this.color,
    required this.size,
    required this.delay,
  });

  @override
  State<_AuraRing> createState() => _AuraRingState();
}

class _AuraRingState extends State<_AuraRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.color.withAlpha(
                (77 * (1 - _animation.value)).toInt(),
              ),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withAlpha(
                  (51 * (1 - _animation.value)).toInt(),
                ),
                blurRadius: 20 * _animation.value,
                spreadRadius: 5 * _animation.value,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Compact icon button for header actions
class CompactIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  const CompactIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: AppColors.onSurfaceVariant, size: 22),
        ),
      ),
    );
  }
}

/// Desktop navigation link widget
class DesktopNavLink extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const DesktopNavLink(this.label, this.isActive, {this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

/// Desktop icon button
class DesktopIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const DesktopIconButton({required this.icon, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: AppColors.onSurfaceVariant),
      iconSize: 20,
      onPressed: onTap ?? () {},
    );
  }
}

/// Desktop play button with large circular design
class DesktopPlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  const DesktopPlayButton({
    required this.isPlaying,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
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
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
}

/// Desktop control button (skip/next)
class DesktopControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const DesktopControlButton({required this.icon, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: AppColors.onSurfaceVariant),
      iconSize: 32,
      onPressed: onPressed ?? () {},
    );
  }
}

/// Desktop timer chip
class DesktopTimerChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const DesktopTimerChip({
    required this.label,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withAlpha(51)
            : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.outlineVariant,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Desktop mixer item for background noise selection
class DesktopMixerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double value;
  final bool isActive;
  final VoidCallback onTap;

  const DesktopMixerItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withAlpha(26)
              : AppColors.surfaceContainerLow.withAlpha(77),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (value > 0)
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha((255 * value).toInt()),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Desktop preset list item
class DesktopPresetListItem extends StatelessWidget {
  final BrainwavePreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  const DesktopPresetListItem({
    required this.preset,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(preset.accentColorValue);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(26) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.outlineVariant.withAlpha(51),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withAlpha(51),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.music_note, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    preset.name,
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${preset.beatFrequency.toStringAsFixed(1)} Hz • ${preset.band.name}',
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: color, size: 18),
          ],
        ),
      ),
    );
  }
}

/// Desktop session stats widget
class DesktopSessionStats extends StatelessWidget {
  const DesktopSessionStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatRow('Total Sessions', '0'),
        const SizedBox(height: 8),
        _buildStatRow('This Week', '0'),
        const SizedBox(height: 8),
        _buildStatRow('Current Streak', '0 days'),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

/// Mobile preset card for horizontal list
class PresetCard extends StatelessWidget {
  final BrainwavePreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  const PresetCard({
    required this.preset,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(preset.accentColorValue);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(51) : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : AppColors.outlineVariant.withAlpha(51),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withAlpha(77),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.music_note, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              preset.name,
              style: const TextStyle(
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${preset.beatFrequency.toStringAsFixed(1)} Hz',
              style: const TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
