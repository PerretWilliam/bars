import 'package:drift/drift.dart' hide isNull;
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

  test('updateTimecode sets and clears a line\'s timecode', () async {
    await controller.addLigne(projetId: 1, ordre: 0);
    final ligne = (await db.select(db.lignes).get()).single;

    await controller.updateTimecode(ligne.id, 4200);
    var updated = await (db.select(
      db.lignes,
    )..where((l) => l.id.equals(ligne.id))).getSingle();
    expect(updated.timecodeMs, 4200);

    await controller.updateTimecode(ligne.id, null);
    updated = await (db.select(
      db.lignes,
    )..where((l) => l.id.equals(ligne.id))).getSingle();
    expect(updated.timecodeMs, isNull);
  });
}
