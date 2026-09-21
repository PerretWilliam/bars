import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/providers/dossiers_provider.dart';

void main() {
  late AppDatabase db;
  late DossiersController controller;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    controller = DossiersController(db);
  });

  tearDown(() => db.close());

  test('create inserts a folder row', () async {
    await controller.create('Freestyles');

    final dossiers = await db.select(db.dossiers).get();
    expect(dossiers.single.nom, 'Freestyles');
  });

  test('rename changes the folder name', () async {
    final id = await controller.create('Old name');

    await controller.rename(id, 'New name');

    final dossier = await db.select(db.dossiers).getSingle();
    expect(dossier.nom, 'New name');
  });

  test('delete removes the folder without deleting its projects', () async {
    final id = await controller.create('To delete');
    final projetId = await db
        .into(db.projets)
        .insert(
          ProjetsCompanion.insert(nom: 'Still here', dossierId: Value(id)),
        );

    await controller.delete(id);

    expect(await db.select(db.dossiers).get(), isEmpty);
    final projet = await db.select(db.projets).getSingle();
    expect(projet.id, projetId);
    expect(projet.dossierId, isNull);
  });
}
