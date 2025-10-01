# Home Center Products — English

Overview
--------
This repository contains a small Flutter application implemented as a technical challenge. Although the task itself is simple, the project was implemented following Clean Architecture principles to demonstrate solid engineering practices and maintainability suitable for production-like codebases.

Environment & Flutter version
-----------------------------
- Flutter channel: stable
- Tested with Flutter 3.32.x and Dart 3.8.x (see `pubspec.yaml` environment sdk).
- To open and run the project you need:
  - Flutter SDK installed and on the PATH
  - Android SDK (for Android builds) or Xcode (for iOS builds)
  - Run `flutter pub get` from the repository root to install dependencies

How to run
----------
1. flutter pub get
2. flutter run

Initial challenge requirements
------------------------------
- Implement a product search and a cart screen with basic add/remove behavior.
- Implement infinite scrolling for the product list.
- Provide tests and enforce coverage thresholds in CI per module.

Why Clean Architecture was used
------------------------------
Although the original challenge was small, the project uses Clean Architecture to:
- Separate domain, infrastructure and presentation layers
- Make use cases and entities independent from frameworks
- Demonstrate ability to structure testable, maintainable code

Project modularization
---------------------
The codebase is modularized into packages to limit library scope per area:
- `module/domain` – domain entities, repositories (interfaces), and use-cases
- `module/infrastructure` – implementations, network/cache/DB and DAOs
- Root app – presentation layer, DI composition, app wiring

Design patterns and architectural decisions
-----------------------------------------
- BLoC for state management in presentation (flutter_bloc)
- Dependency Injection with `get_it` + `injectable`
- Repository pattern to abstract data sources
- Translators/Mapper pattern to convert between DTOs and domain entities
- Proxy for API caching/proxying layers
- DAO (Drift) for local persistence

SOLID
-----
The implementation follows SOLID principles: single responsibility for small widgets and classes, dependency inversion through repository abstractions and DI, and other best practices to keep code maintainable.

Performance improvements for widgets
-----------------------------------
- Use const constructors where possible
- Keep widgets small and focused to reduce rebuild scopes
- Use `cached_network_image` for remote images to reduce redraws and network
- Avoid unnecessary work in build methods and hoist expensive calculations

Testing
-------
- Unit tests: domain and use cases
- Widget tests: presentation widgets (rendering, interactions and semantics)
- Integration tests: where relevant to ensure flows work end-to-end
- Golden tests: UI regression baselines for key widgets
- Accessibility/semantics tests: ensure widgets expose labels and semantics correctly

Testing practices
-----------------
- Tests follow Triple-A (Arrange-Act-Assert) pattern and FIRST principles (Fast, Independent, Repeatable, Self-validating, Timely)
- Mocks and fakes are used to isolate units under test
- Tests include localization delegates to make assertions locale-aware and robust

Code style and maintainability
-----------------------------
- Clear naming conventions for files, classes and tests
- Small reusable widgets and consistent styling
- Linting with `very_good_analysis` recommended preset (see `analysis_options.yaml`)

Localization
------------
- Strings are localized using Flutter's `gen_l10n` (ARB files under `lib/l10n`) and the generated classes are used in the app.

CI / Pipeline
-------------
- GitHub Actions pipeline included to run tests, analyze code and check coverage per module.
- Coverage thresholds are enforced for modules (domain, infrastructure, presentation) via custom scripts in `tool/ci/`.
