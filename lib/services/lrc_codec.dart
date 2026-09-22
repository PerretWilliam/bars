/// Reads and writes project lyrics as a standard LRC (`.lrc`) document, so a
/// project's lines are portable to any LRC-compatible player, not just Bars.
///
/// Bars-specific fields that plain LRC has no tag for (production link,
/// creation date, bundled-audio duration) are stored as `#`-prefixed comment
/// lines. LRC readers that don't recognize a line fall back to treating it
/// as plain (unsynced) text, so the file stays readable elsewhere even
/// though those extra lines won't make sense out of context.
library;

class LrcLine {
  const LrcLine({required this.text, this.timecodeMs});

  final String text;
  final int? timecodeMs;
}

class LrcProject {
  const LrcProject({
    required this.title,
    required this.language,
    required this.createdAt,
    required this.lines,
    this.prodLink,
    this.audioDurationMs,
  });

  final String title;
  final String language;
  final DateTime createdAt;
  final List<LrcLine> lines;
  final String? prodLink;
  final int? audioDurationMs;
}

final _timecodePattern = RegExp(r'^\[(\d{2}):(\d{2})(?:\.(\d{1,3}))?\](.*)$');

String _formatTimecode(int ms) {
  final minutes = ms ~/ 60000;
  final seconds = (ms % 60000) ~/ 1000;
  final centiseconds = (ms % 1000) ~/ 10;
  return '[${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}.'
      '${centiseconds.toString().padLeft(2, '0')}]';
}

String encodeLrc(LrcProject project) {
  final buffer = StringBuffer()
    ..writeln('[ti:${project.title}]')
    ..writeln('[la:${project.language}]')
    ..writeln('[re:Bars]')
    ..writeln('#created:${project.createdAt.toIso8601String()}');
  if (project.prodLink != null) {
    buffer.writeln('#prod:${project.prodLink}');
  }
  if (project.audioDurationMs != null) {
    buffer.writeln('#audioDurationMs:${project.audioDurationMs}');
  }
  for (final line in project.lines) {
    final timecodeMs = line.timecodeMs;
    buffer.writeln(
      timecodeMs == null
          ? line.text
          : '${_formatTimecode(timecodeMs)}${line.text}',
    );
  }
  return buffer.toString();
}

LrcProject decodeLrc(String content) {
  var title = '';
  var language = 'fr';
  var createdAt = DateTime.now();
  String? prodLink;
  int? audioDurationMs;
  final lines = <LrcLine>[];

  for (final rawLine in content.split(RegExp(r'\r\n|\n'))) {
    final line = rawLine.trim();
    if (line.isEmpty) continue;

    final titleMatch = RegExp(r'^\[ti:(.*)\]$').firstMatch(line);
    if (titleMatch != null) {
      title = titleMatch.group(1)!;
      continue;
    }
    final langMatch = RegExp(r'^\[la:(.*)\]$').firstMatch(line);
    if (langMatch != null) {
      language = langMatch.group(1)!;
      continue;
    }
    if (line.startsWith('[re:') || line.startsWith('[ve:')) continue;

    final createdMatch = RegExp(r'^#created:(.*)$').firstMatch(line);
    if (createdMatch != null) {
      createdAt = DateTime.tryParse(createdMatch.group(1)!) ?? createdAt;
      continue;
    }
    final prodMatch = RegExp(r'^#prod:(.*)$').firstMatch(line);
    if (prodMatch != null) {
      prodLink = prodMatch.group(1)!;
      continue;
    }
    final audioDurationMatch = RegExp(r'^#audioDurationMs:(\d+)$')
        .firstMatch(line);
    if (audioDurationMatch != null) {
      audioDurationMs = int.parse(audioDurationMatch.group(1)!);
      continue;
    }
    if (line.startsWith('#')) continue;

    final timecodeMatch = _timecodePattern.firstMatch(line);
    if (timecodeMatch != null) {
      final minutes = int.parse(timecodeMatch.group(1)!);
      final seconds = int.parse(timecodeMatch.group(2)!);
      final fraction = (timecodeMatch.group(3) ?? '0').padRight(3, '0');
      final ms =
          minutes * 60000 +
          seconds * 1000 +
          int.parse(fraction.substring(0, 3));
      lines.add(LrcLine(text: timecodeMatch.group(4)!, timecodeMs: ms));
    } else {
      lines.add(LrcLine(text: line));
    }
  }

  return LrcProject(
    title: title,
    language: language,
    createdAt: createdAt,
    lines: lines,
    prodLink: prodLink,
    audioDurationMs: audioDurationMs,
  );
}
