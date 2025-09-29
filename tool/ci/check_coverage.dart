#!/usr/bin/env dart
// Simple lcov coverage checker.
// Usage: dart run tool/ci/check_coverage.dart <path-to-lcov.info> <min-percentage>
import 'dart:io';

void main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('Usage: dart run tool/ci/check_coverage.dart <lcov.info> <minPercent>');
    exit(2);
  }

  final path = args[0];
  final minPercent = double.tryParse(args[1]) ?? 0.0;

  final file = File(path);
  if (!await file.exists()) {
    stderr.writeln('Coverage file not found: $path');
    exit(2);
  }

  final lines = await file.readAsLines();
  int totalLines = 0;
  int coveredLines = 0;

  for (final line in lines) {
    if (line.startsWith('LF:')) {
      final value = int.tryParse(line.substring(3)) ?? 0;
      totalLines += value;
    } else if (line.startsWith('LH:')) {
      final value = int.tryParse(line.substring(3)) ?? 0;
      coveredLines += value;
    }
  }

  final percent = totalLines == 0 ? 0.0 : (coveredLines / totalLines) * 100.0;
  stdout.writeln('Coverage summary for $path: ${coveredLines}/$totalLines => ${percent.toStringAsFixed(2)}%');

  if (percent < minPercent) {
    stderr.writeln('Coverage check failed: $percent% < required $minPercent%');
    exit(3);
  }

  stdout.writeln('Coverage check passed: $percent% >= $minPercent%');
  exit(0);
}
