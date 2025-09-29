// Script: tool/ci/analyze_check.dart
// Usage: dart run tool/ci/analyze_check.dart analyze.json

import 'dart:convert';
import 'dart:io';

Future<int> main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln('Usage: analyze_check.dart <analyze_json_file>');
    return 2;
  }
  final file = File(args[0]);
  if (!await file.exists()) {
    stderr.writeln('File not found: ${args[0]}');
    return 2;
  }

  final content = await file.readAsString();
  // flutter analyze --format=json may output multiple JSON objects separated by newlines
  // We'll parse leniently: find the first JSON array/object
  dynamic parsed;
  try {
    parsed = jsonDecode(content);
  } catch (_) {
    // try to recover by reading last line that looks like JSON
    final lines = content.trim().split(RegExp(r'\r?\n'));
    for (var i = lines.length - 1; i >= 0; i--) {
      final l = lines[i].trim();
      if (l.isEmpty) continue;
      try {
        parsed = jsonDecode(l);
        break;
      } catch (_) {}
    }
  }

  if (parsed == null) {
    stderr.writeln('Could not parse analyze JSON file');
    return 2;
  }

  // The analyzer JSON contains 'issues' array
  final issues = <Map<String, dynamic>>[];
  if (parsed is Map && parsed['issues'] is List) {
    for (final it in parsed['issues']) {
      if (it is Map<String, dynamic>) issues.add(it);
    }
  } else if (parsed is List) {
    for (final item in parsed) {
      if (item is Map && item['issues'] is List) {
        for (final it in item['issues']) {
          if (it is Map<String, dynamic>) issues.add(it);
        }
      }
    }
  }

  var errors = 0;
  var warnings = 0;
  var infos = 0;
  for (final it in issues) {
    final severity = (it['severity'] ?? '').toString().toLowerCase();
    if (severity == 'error') errors++;
    if (severity == 'warning') warnings++;
    if (severity == 'info') infos++;
  }

  stdout.writeln('Analyzer found: errors=$errors warnings=$warnings info=$infos total=${issues.length}');

  // Print a short table of first few issues
  final preview = issues.take(10).toList();
  for (final it in preview) {
    final filePath = it['location']?['file'] ?? it['file'] ?? '<unknown>';
    final line = it['location']?['range']?['start']?['line'] ?? it['line'] ?? '?';
    final message = it['message'] ?? it['problemMessage'] ?? it['messageText'] ?? '';
    final sev = it['severity'] ?? '';
    stdout.writeln(' - ${sev.toString().toUpperCase()} $filePath:$line: $message');
  }

  if (errors > 0) {
    stderr.writeln('Failing CI because analyzer reported $errors error(s).');
    return 1;
  }

  // exit 0 if only warnings/infos
  return 0;
}
