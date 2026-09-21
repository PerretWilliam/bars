# Contributing to Bars

Thanks for your interest in contributing! Bars is a small, personal project
now open to contributions — here's how to get set up and what's expected of
a pull request.

## Getting started

```bash
flutter pub get
flutter run
```

The Flutter SDK is required (see `environment.sdk` in `pubspec.yaml` for the
minimum version). If you touch a `freezed`/`json_serializable`/`drift`
source file, regenerate the generated code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

If you touch a localized string, regenerate `AppLocalizations`:

```bash
flutter gen-l10n
```

## Before opening a pull request

Run all of the following and make sure they pass:

```bash
dart format .
flutter analyze
flutter test
```

- **Format**: run `dart format .` after any change to `.dart` files. Never
  leave unformatted code in a commit.
- **Lint clean**: `flutter analyze` must report no issues. Don't suppress
  warnings with `// ignore:` unless there's a documented reason inline.
- **Tests**: add or update a test when behavior changes in `lib/data`,
  `lib/providers`, or `lib/services`. UI screens should get at least a smoke
  test.
- **Localization**: the UI ships in English and French via
  `flutter_localizations` + ARB files (`lib/l10n/app_en.arb`,
  `lib/l10n/app_fr.arb`). Every user-facing string goes through
  `AppLocalizations`, never a hardcoded literal. Add a key to both ARB
  files and run `flutter gen-l10n`.
- **English only in code**: all code, identifiers, comments, and commit
  messages are in English, even though the product owner communicates in
  French. Content the app *processes* (lyrics, detected line language,
  dictionary data) is naturally whatever language the user writes — that's
  content, not code.
- **Never reimplement a library**: before writing custom logic (parsing,
  rhyme matching, waveform rendering, drag-reorder, zip packaging, etc.),
  check for an existing well-maintained package first.

## Project structure

```
lib/
  main.dart
  data/       # drift database, tables, hand-maintained config (changelog, donation)
  models/     # freezed + json_serializable data classes
  providers/  # riverpod providers, one file per domain
  services/   # business logic that isn't a simple provider
  l10n/       # ARB source files + generated AppLocalizations
  ui/
    screens/
    widgets/
  router/     # go_router configuration
```

Keep new files inside these folders unless a genuinely new, cross-cutting
concern appears.

## Commits and pull requests

- Small, scoped commits; message in English, imperative mood (e.g.
  `Add drift schema for projets/lignes/audios`).
- Describe *why* in the PR description, not just what changed.
- Bump `pubspec.yaml`'s `version:` only when cutting a release, and add a
  matching entry to `lib/data/changelog.dart`.

See [CLAUDE.md](CLAUDE.md) for the full set of conventions this project
follows (including guidance written for AI coding agents, which applies
equally to human contributors) and [ROADMAP.md](ROADMAP.md) for what's
planned.
