// ignore_for_file: avoid_print
import 'dart:io';

void main() {
  final src = File('coverage/lcov.info');
  final dst = File('coverage/lcov_clean.info');
  if (!src.existsSync()) return;
  final sink = dst.openWrite();
  bool skip = false;
  int lfTotal = 0, lhTotal = 0;
  int currentLf = 0, currentLh = 0;
  
  for (var line in src.readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      skip = line.endsWith('.g.dart');
      currentLf = 0; 
      currentLh = 0;
    }
    if (!skip) {
      sink.writeln(line);
      if (line.startsWith('LF:')) currentLf = int.parse(line.substring(3));
      if (line.startsWith('LH:')) currentLh = int.parse(line.substring(3));
      if (line == 'end_of_record') {
        lfTotal += currentLf;
        lhTotal += currentLh;
      }
    }
  }
  sink.close();
  print('Total LF: $lfTotal, LH: $lhTotal, Pct: ${(lhTotal * 100 / lfTotal).toStringAsFixed(2)}%');
}
