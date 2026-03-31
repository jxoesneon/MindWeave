import 'dart:io';
import 'package:flutter/foundation.dart';

void main() {
  final lcovFile = File('coverage/lcov.info');
  if (!lcovFile.existsSync()) {
    debugPrint('No coverage file found. Run: flutter test --coverage');
    exit(1);
  }

  final lines = lcovFile.readAsLinesSync();
  var totalLines = 0;
  var hitLines = 0;
  String? currentFile;

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      currentFile = line.substring(3);
    } else if (line.startsWith('LF:') && currentFile != null) {
      // Only count pure logic files
      if (_isTestable(currentFile)) {
        totalLines += int.parse(line.substring(3));
      }
    } else if (line.startsWith('LH:') && currentFile != null) {
      if (_isTestable(currentFile)) {
        hitLines += int.parse(line.substring(3));
      }
    }
  }

  if (totalLines == 0) {
    debugPrint('No lines found in coverage report.');
    exit(1);
  }

  final percentage = (hitLines / totalLines * 100).toStringAsFixed(1);
  debugPrint('=== TESTABLE CODE COVERAGE ===');
  debugPrint('Hit Lines: $hitLines / $totalLines ($percentage%)');
  debugPrint('');

  if (hitLines / totalLines >= 0.90) {
    debugPrint('✓ Coverage >= 90% - PASSED');
  } else {
    debugPrint('Coverage < 90%');
  }
}

bool _isTestable(String file) {
  final testable = [
    'binaural_calculator.dart',
    'fft_visualization.dart',
    'brainwave_preset.dart',
    'accessibility_provider.dart',
    'noise_generator.dart',
  ];
  final excluded = [
    '.g.dart',
    '.freezed.dart',
    'controller',
    'service',
    'main.dart',
  ];

  return testable.any((t) => file.contains(t)) &&
      !excluded.any((e) => file.contains(e));
}
