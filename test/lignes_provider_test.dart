import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/providers/lignes_provider.dart';

void main() {
  late AppDatabase db;
  late LignesController controller;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    controller = LignesController(db);
    await db
        .into(db.projets)
        .insert(ProjetsCompanion.insert(nom: 'Test project'));
  });

  tearDown(() => db.close());

  test('addLigne appends at the given order', () async {
    await controller.addLigne(projetId: 1, ordre: 0);
    await controller.addLigne(projetId: 1, ordre: 1);

    final lignes = await db.select(db.lignes).get();
    expect(lignes.map((l) => l.ordre), [0, 1]);
  });

  test('deleteLigne removes only the targeted line', () async {
    await controller.addLigne(projetId: 1, ordre: 0);
    await controller.addLigne(projetId: 1, ordre: 1);
    final lignes = await db.select(db.lignes).get();

    await controller.deleteLigne(lignes.first.id);

    final remaining = await db.select(db.lignes).get();
    expect(remaining.length, 1);
    expect(remaining.first.id, lignes.last.id);
  });

  test('reorder persists the new order indices', () async {
    await controller.addLigne(projetId: 1, ordre: 0);
    await controller.addLigne(projetId: 1, ordre: 1);
    final lignes = await db.select(db.lignes).get();

    await controller.reorder(lignes.reversed.toList());

    final reordered = await (db.select(
      db.lignes,
    )..orderBy([(l) => OrderingTerm(expression: l.ordre)])).get();
    expect(reordered.map((l) => l.id), [lignes.last.id, lignes.first.id]);
  });
}
