# home_center_products

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## CI coverage

The CI workflow produces per-module coverage reports (domain, infrastructure,
presentation blocs and presentation widgets). Each module runs tests with
coverage enabled, the resulting `lcov.info` is checked against a minimum
threshold and uploaded as an artifact. Thresholds are configured in
`.github/workflows/ci.yml` and the coverage check script is `tool/ci/check_coverage.dart`.

Adjust thresholds in the workflow if you need stricter/looser requirements.

Defaults in the workflow (can be adjusted):
- Domain coverage minimum: 90%
- Infrastructure coverage minimum: 60%
- Presentation (blocs/widgets) minimums: 50%

Change those values by editing the environment variables at the top of `.github/workflows/ci.yml`.
