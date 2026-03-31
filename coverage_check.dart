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

  for (final line in lines) {
    if (line.startsWith('LF:')) {
      totalLines += int.parse(line.substring(3));
    } else if (line.startsWith('LH:')) {
      hitLines += int.parse(line.substring(3));
    }
  }

  if (totalLines == 0) {
    debugPrint('No lines found in coverage report.');
    exit(1);
  }

  final percentage = (hitLines / totalLines * 100).toStringAsFixed(1);
  debugPrint('Coverage: $hitLines / $totalLines lines ($percentage%)');

  if (hitLines / totalLines >= 0.90) {
    debugPrint('✓ Coverage requirement met (>= 90%)');
  } else {
    debugPrint('✗ Coverage below 90% - need more tests');
    exit(1);
  }
}
