import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/services/database_seeder.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test(
    'seedIfEmpty inserts sample projects and lines when the db is empty',
    () async {
      await DatabaseSeeder(db).seedIfEmpty();

      final projets = await db.select(db.projets).get();
      expect(projets.length, 2);

      final lignes = await db.select(db.lignes).get();
      expect(lignes, isNotEmpty);
      for (final ligne in lignes) {
        expect(projets.map((p) => p.id), contains(ligne.projetId));
      }
    },
  );

  test('seedIfEmpty does nothing when a project already exists', () async {
    await db
        .into(db.projets)
        .insert(ProjetsCompanion.insert(nom: 'Real project'));

    await DatabaseSeeder(db).seedIfEmpty();

    final projets = await db.select(db.projets).get();
    expect(projets.length, 1);
    expect(projets.single.nom, 'Real project');
  });
}
