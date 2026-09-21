class ChangelogEntry {
  const ChangelogEntry({
    required this.version,
    required this.date,
    required this.changes,
  });

  final String version;
  final DateTime date;
  final List<String> changes;
}

/// Hand-maintained release notes, newest first. Add an entry here whenever
/// `pubspec.yaml`'s `version:` is bumped for a new build, per CLAUDE.md's
/// workflow conventions.
final changelog = [
  ChangelogEntry(
    version: '1.0.0',
    date: DateTime(2026, 9, 21),
    changes: const [
      'Write, reorder, and delete lyric lines, with live rhyme suggestions in French and English',
      'Timecoded mode: import an audio file and mark each line at its exact moment in the track',
      'Rap mode: a full-screen, auto-scrolling display synced to playback',
      'Export and import projects as .rapproj bundles',
      'Light and dark theme, a full icon set, and a French/English localized UI',
      'Folders, a list/grid view toggle, and app info/legal/donate pages',
    ],
  ),
];
