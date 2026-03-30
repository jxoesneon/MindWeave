import 'dart:io';
import 'dart:convert';

void main() {
  final file = File('coverage/lcov.info');
  if (!file.existsSync()) return;
  final lines = file.readAsLinesSync();
  
  String currentFile = '';
  int lf = 0, lh = 0;
  List<Map<String, dynamic>> results = [];
  
  for (var line in lines) {
    if (line.startsWith('SF:')) {
      currentFile = line.substring(3);
    } else if (line.startsWith('LF:')) {
      lf = int.parse(line.substring(3));
    } else if (line.startsWith('LH:')) {
      lh = int.parse(line.substring(3));
    } else if (line == 'end_of_record') {
      if (lf > 0) {
        var pct = (lh / lf) * 100;
        if (pct < 90) {
            results.add({'file': currentFile, 'pct': pct, 'lf': lf, 'lh': lh});
        }
      }
      lf = 0; lh = 0;
    }
  }
  
  results.sort((a, b) => (a['pct'] as double).compareTo(b['pct'] as double));
  var out = File('cov_utf8.txt');
  var sink = out.openWrite(encoding: utf8);
  for (var r in results) {
    sink.writeln('${(r['pct'] as double).toStringAsFixed(2)}% (${r['lh']}/${r['lf']}): ${r['file']}');
  }
  sink.close();
}
