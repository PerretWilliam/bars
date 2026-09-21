import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/services/rhyme_dictionary_importer.dart';

void main() {
  late AppDatabase db;
  late RhymeDictionaryImporter importer;
  late Directory tempDir;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    importer = RhymeDictionaryImporter(db);
    tempDir = await Directory.systemTemp.createTemp('rhyme_import_test');
  });

  tearDown(() async {
    await db.close();
    await tempDir.delete(recursive: true);
  });

  test('imports Lexique rows and groups rhyming words by rime key', () async {
    final file = File('${tempDir.path}/lexique.tsv');
    await file.writeAsString(
      'ortho\tphon\tcgram\n'
      'maison\tmEz§\tNOM\n'
      'chanson\tS@s§\tNOM\n'
      'blanc\tbl@\tADJ\n',
    );

    final count = await importer.importFrench(file);
    expect(count, 3);

    final maison = await (db.select(
      db.rhymes,
    )..where((r) => r.mot.equals('maison'))).getSingle();
    final chanson = await (db.select(
      db.rhymes,
    )..where((r) => r.mot.equals('chanson'))).getSingle();

    expect(maison.rimeKey, chanson.rimeKey);
    expect(maison.langue, 'fr');
  });

  test('imports CMU rows keyed on the primary-stressed vowel onward', () async {
    final file = File('${tempDir.path}/cmudict.dict');
    await file.writeAsString(
      ';;; comment lines are skipped\n'
      'nation N EY1 SH AH0 N\n'
      'station S T EY1 SH AH0 N\n',
    );

    final count = await importer.importEnglish(file);
    expect(count, 2);

    final nation = await (db.select(
      db.rhymes,
    )..where((r) => r.mot.equals('nation'))).getSingle();
    final station = await (db.select(
      db.rhymes,
    )..where((r) => r.mot.equals('station'))).getSingle();

    expect(nation.rimeKey, station.rimeKey);
    expect(nation.langue, 'en');
  });

  test('re-importing a language replaces its previous entries', () async {
    final first = File('${tempDir.path}/first.tsv');
    await first.writeAsString('ortho\tphon\nmaison\tmEz§\n');
    await importer.importFrench(first);

    final second = File('${tempDir.path}/second.tsv');
    await second.writeAsString('ortho\tphon\nchanson\tS@s§\n');
    final count = await importer.importFrench(second);

    expect(count, 1);
    final rows = await db.select(db.rhymes).get();
    expect(rows.map((r) => r.mot), ['chanson']);
  });
}
