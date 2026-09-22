import '../l10n/app_localizations.dart';

class ChangelogEntry {
  const ChangelogEntry({
    required this.version,
    required this.date,
    required this.changes,
  });

  final String version;
  final DateTime date;

  /// Localized bullet points for this entry.
  final List<String> Function(AppLocalizations l10n) changes;
}

/// Hand-maintained release notes, newest first. Add an entry here whenever
/// `pubspec.yaml`'s `version:` is bumped for a new build, per CLAUDE.md's
/// workflow conventions — the bullet points are localized, so add a key to
/// both `app_en.arb` and `app_fr.arb` for each one.
final changelog = [
  ChangelogEntry(
    version: '1.1.0',
    date: DateTime(2026, 9, 22),
    changes: (l10n) => [
      l10n.changelog110StandardFormat,
      l10n.changelog110CleanerToolbar,
      l10n.changelog110ConsistentSpacing,
    ],
  ),
  ChangelogEntry(
    version: '1.0.0',
    date: DateTime(2026, 9, 21),
    changes: (l10n) => [
      l10n.changelog100Notepad,
      l10n.changelog100Timecoded,
      l10n.changelog100RapMode,
      l10n.changelog100ExportImport,
      l10n.changelog100ThemeAndIcons,
      l10n.changelog100FoldersAndInfo,
    ],
  ),
];
