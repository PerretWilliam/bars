# CLAUDE.md

Guidance for Claude Code (and any contributor) working in this repository.

## Project

Flutter app for writing rap lyrics, finding rhymes, and syncing lines to audio timecodes.
See [ROADMAP.md](ROADMAP.md) for the phased implementation plan.

## Language conventions

- **All code, identifiers, comments, commit messages, and code-review notes are in English.** No French in source files, even though the product owner communicates in French.
- **The app UI itself ships in English only for now.** Do not add localization (`flutter_localizations`, `.arb` files, `intl`) until a phase explicitly asks for it — French/other translations come later as a dedicated pass, not incrementally.
- Exception: linguistic *data* the app processes (French rhyme dictionary, detected line language, user lyrics content) is naturally French/English/whatever the user writes — that's content, not UI or code.

## Core policy (from ROADMAP.md)

**Never implement manually what a library already does.** Before writing custom logic (parsing, rhyme matching, audio waveform rendering, drag-reorder lists, archive/zip packaging, etc.), check for an existing well-maintained package first.

## Project structure

```
lib/
  main.dart
  models/     # freezed + json_serializable data classes (Projet, Ligne, Audio)
  data/       # drift database, tables, DAOs
  providers/  # riverpod providers, one file per domain (projets, lignes, audio)
  services/   # business logic that isn't a simple provider (import/export, file handling)
  ui/
    screens/
    widgets/
  router/     # go_router configuration
```

Keep new files inside these folders. Only add a new top-level folder under `lib/` when a whole new concern appears (e.g. `lib/utils/` if truly cross-cutting) — don't create one-off folders for a single file.

## Workflow conventions

- **Format after every edit**: run `dart format .` (or the equivalent single-file format) after any change to `.dart` files. Never leave unformatted code in a commit.
- **Lint clean**: run `flutter analyze` before considering a change done. Fix warnings; don't suppress them with `// ignore:` unless there's a documented reason inline.
- **Codegen**: after touching a `freezed`/`json_serializable`/`drift` source file (anything with a `part '*.g.dart'` or `part '*.freezed.dart'`), regenerate with:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
  Do not hand-edit generated `.g.dart` / `.freezed.dart` files.
- **Dependency versions**: when adding a package, use `flutter pub add <package>` (and `--dev` for dev dependencies) rather than hand-editing `pubspec.yaml` version constraints, so the resolved version is always compatible with the current Flutter/Dart SDK.
- **Bump versions deliberately**: bump `pubspec.yaml`'s `version:` (`major.minor.patch+build`) only when asked to cut a release/build, not on every commit. Patch = bug fix, minor = new feature/phase completed, build number increments on every distributed build (APK/IPA).
- **Tests**: add/update a test when behavior changes in `lib/data`, `lib/providers`, or `lib/services`. UI screens get at least a smoke test. Run `flutter test` before marking a task done.
- **Commits**: small, scoped commits; message in English, imperative mood (e.g. `Add drift schema for projets/lignes/audios`).

## Local environment notes

- Flutter SDK lives at `~/Applications/flutter` — not on PATH by default in fresh shells. If `flutter`/`dart` commands aren't found, prepend `$HOME/Applications/flutter/bin` to `PATH` for that shell.
- The iOS Simulator (iPhone 17) is available and is the primary manual-verification target. Android toolchain (cmdline-tools) is not installed yet; revisit before Phase 6 (Android APK build).
- **When verifying a change on the iOS Simulator, always `attach` the simulator panel (not just take private screenshots) so the user can watch the live session.** Do this before building/launching, per the simulator tool's own guidance.
