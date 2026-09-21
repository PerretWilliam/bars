import 'dart:convert';
import 'dart:io';

import '../data/app_database.dart';
import 'rime_key.dart';

const _batchSize = 500;
final _cmuVariantSuffix = RegExp(r'\(\d+\)$');

class RhymeDictionaryImporter {
  RhymeDictionaryImporter(this._db);

  final AppDatabase _db;

  /// Parses a Lexique383 TSV export and imports it as French rhyme entries.
  /// Returns the number of imported (word, rime) pairs.
  Future<int> importFrench(File lexiqueTsv) async {
    final entries = <RhymesCompanion>[];
    final seen = <String>{};
    var isHeader = true;
    var orthoIndex = -1;
    var phonIndex = -1;

    await for (final line in _readLines(lexiqueTsv)) {
      if (line.isEmpty) continue;
      final columns = line.split('\t');
      if (isHeader) {
        orthoIndex = columns.indexOf('ortho');
        phonIndex = columns.indexOf('phon');
        isHeader = false;
        continue;
      }
      if (orthoIndex == -1 || phonIndex == -1) break;
      if (columns.length <= orthoIndex || columns.length <= phonIndex) {
        continue;
      }

      final mot = columns[orthoIndex].toLowerCase();
      final phon = columns[phonIndex];
      if (mot.isEmpty || phon.isEmpty) continue;

      final rimeKey = rimeKeyFr(phon);
      if (rimeKey == null) continue;
      if (!seen.add('$mot|$rimeKey')) continue;

      entries.add(
        RhymesCompanion.insert(mot: mot, rimeKey: rimeKey, langue: 'fr'),
      );
    }

    await _replaceLanguage('fr', entries);
    return entries.length;
  }

  /// Parses a CMU Pronouncing Dictionary export and imports it as English
  /// rhyme entries. Returns the number of imported (word, rime) pairs.
  Future<int> importEnglish(File cmuDict) async {
    final entries = <RhymesCompanion>[];
    final seen = <String>{};

    await for (final line in _readLines(cmuDict)) {
      if (line.isEmpty || line.startsWith(';;;')) continue;
      final parts = line.trim().split(RegExp(r'\s+'));
      if (parts.length < 2) continue;

      final mot = parts.first.replaceFirst(_cmuVariantSuffix, '').toLowerCase();
      final phonemes = parts.sublist(1);
      final rimeKey = rimeKeyEn(phonemes);
      if (mot.isEmpty || rimeKey == null) continue;
      if (!seen.add('$mot|$rimeKey')) continue;

      entries.add(
        RhymesCompanion.insert(mot: mot, rimeKey: rimeKey, langue: 'en'),
      );
    }

    await _replaceLanguage('en', entries);
    return entries.length;
  }

  Stream<String> _readLines(File file) {
    return file
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter());
  }

  Future<void> _replaceLanguage(String langue, List<RhymesCompanion> entries) {
    return _db.transaction(() async {
      await (_db.delete(
        _db.rhymes,
      )..where((r) => r.langue.equals(langue))).go();
      for (var i = 0; i < entries.length; i += _batchSize) {
        final end = (i + _batchSize < entries.length)
            ? i + _batchSize
            : entries.length;
        final chunk = entries.sublist(i, end);
        await _db.batch((batch) => batch.insertAll(_db.rhymes, chunk));
      }
    });
  }
}
