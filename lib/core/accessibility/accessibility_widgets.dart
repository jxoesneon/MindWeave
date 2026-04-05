import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Accessibility helper widgets and utilities

/// Semantics wrapper for common accessibility patterns
class AccessibleWidget extends StatelessWidget {
  final Widget child;
  final String? label;
  final String? hint;
  final String? value;
  final bool isButton;
  final bool isHeader;
  final bool isSelected;
  final VoidCallback? onTap;

  const AccessibleWidget({
    required this.child,
    this.label,
    this.hint,
    this.value,
    this.isButton = false,
    this.isHeader = false,
    this.isSelected = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      value: value,
      button: isButton,
      header: isHeader,
      selected: isSelected,
      onTap: onTap,
      child: child,
    );
  }
}

/// Accessible icon button with proper semantics
class AccessibleIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final VoidCallback onPressed;
  final bool isSelected;

  const AccessibleIconButton({
    required this.icon,
    required this.label,
    required this.hint,
    required this.onPressed,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      selected: isSelected,
      onTap: onPressed,
      child: IconButton(icon: Icon(icon), onPressed: onPressed, tooltip: hint),
    );
  }
}

/// Accessible slider with value announcement
class AccessibleSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final String label;
  final String valueSuffix;
  final ValueChanged<double> onChanged;

  const AccessibleSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.label,
    required this.valueSuffix,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formattedValue = value.toStringAsFixed(1);

    return Semantics(
      label: label,
      value: '$formattedValue $valueSuffix',
      increasedValue:
          '${(value + 1).clamp(min, max).toStringAsFixed(1)} $valueSuffix',
      decreasedValue:
          '${(value - 1).clamp(min, max).toStringAsFixed(1)} $valueSuffix',
      onIncrease: () => onChanged((value + 1).clamp(min, max)),
      onDecrease: () => onChanged((value - 1).clamp(min, max)),
      child: Slider(value: value, min: min, max: max, onChanged: onChanged),
    );
  }
}

/// Accessible preset card
class AccessiblePresetCard extends StatelessWidget {
  final String name;
  final String frequency;
  final String band;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const AccessiblePresetCard({
    required this.name,
    required this.frequency,
    required this.band,
    required this.isSelected,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$name preset, $frequency, $band wave',
      hint: 'Double tap to select this preset',
      button: true,
      selected: isSelected,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withAlpha(51)
                : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.music_note, color: color),
              const SizedBox(height: 8),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(frequency),
            ],
          ),
        ),
      ),
    );
  }
}

/// Accessible play button with large touch target
class AccessiblePlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  const AccessiblePlayButton({
    required this.isPlaying,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isPlaying ? 'Pause playback' : 'Start playback',
      button: true,
      onTap: onPressed,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 80, // Larger touch target
          height: 80,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}

/// Screen reader only text (visible to accessibility services only)
class ScreenReaderOnly extends StatelessWidget {
  final String text;

  const ScreenReaderOnly({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(label: text, child: const SizedBox.shrink());
  }
}

/// Accessibility helper class for common labels
class AccessibilityLabels {
  // Player Screen
  static const String playButton = 'Play binaural beats';
  static const String pauseButton = 'Pause binaural beats';
  static const String stopButton = 'Stop playback';
  static const String timerButton = 'Set session timer';
  static const String libraryButton = 'Open sound library';
  static const String settingsButton = 'Open settings';
  static const String frequencySlider = 'Carrier frequency';
  static const String volumeSlider = 'Volume level';
  static const String presetSelector = 'Brainwave preset';

  // Navigation
  static const String backButton = 'Go back';
  static const String closeButton = 'Close';
  static const String saveButton = 'Save';
  static const String cancelButton = 'Cancel';
  static const String deleteButton = 'Delete';

  // Settings
  static const String themeToggle = 'Toggle dark mode';
  static const String notificationsToggle = 'Enable notifications';
  static const String analyticsToggle = 'Enable analytics';

  // Library
  static const String myLibraryTab = 'My Library tab';
  static const String communityTab = 'Community tab';
  static const String addFavorite = 'Add to favorites';
  static const String removeFavorite = 'Remove from favorites';

  // Frequencies
  static const String frequencyInfo = 'Brainwave frequency information';
  static const String deltaWaves = 'Delta waves, deep sleep';
  static const String thetaWaves = 'Theta waves, meditation';
  static const String alphaWaves = 'Alpha waves, relaxation';
  static const String betaWaves = 'Beta waves, focus';
  static const String gammaWaves = 'Gamma waves, cognition';

  // Common
  static const String loading = 'Loading';
  static const String error = 'Error occurred';
  static const String success = 'Success';
  static const String retry = 'Try again';
}
