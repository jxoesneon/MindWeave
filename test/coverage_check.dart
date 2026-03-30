// ignore_for_file: avoid_print
import 'dart:io';

void main() {
  final lcovFile = File('coverage/lcov.info');
  if (!lcovFile.existsSync()) {
    print('Error: coverage/lcov.info not found. Run `flutter test --coverage` first.');
    return;
  }

  final lines = lcovFile.readAsLinesSync();
  int totalFound = 0;
  int totalHit = 0;

  for (final line in lines) {
    if (line.startsWith('LF:')) {
      totalFound += int.parse(line.split(':')[1]);
    } else if (line.startsWith('LH:')) {
      totalHit += int.parse(line.split(':')[1]);
    }
  }

  final percentage = (totalHit / totalFound) * 100;
  print('========================================');
  print('MindWeave Test Coverage Summary');
  print('========================================');
  print('Total Executable Lines: $totalFound');
  print('Total Hit Lines:        $totalHit');
  print('Overall Coverage:       ${percentage.toStringAsFixed(2)}%');
  print('========================================');
  
  if (percentage >= 90) {
    print('Success: Coverage is over 90%!');
  } else {
    print('Remaining Gap: ${(90 - percentage).toStringAsFixed(2)}%');
  }
}
