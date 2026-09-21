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

  test('addLigne bumps the parent project\'s updatedAt', () async {
    // Backdated so the bump is observable even at drift's second-level
    // DateTime column precision.
    final oldDate = DateTime.now().subtract(const Duration(days: 1));
    await (db.update(db.projets)..where((row) => row.id.equals(1))).write(
      ProjetsCompanion(updatedAt: Value(oldDate)),
    );

    await controller.addLigne(projetId: 1, ordre: 0);

    final after = await db.select(db.projets).getSingle();
    expect(after.updatedAt.isAfter(oldDate), isTrue);
  });

  test('deleteLigne removes only the targeted line', () async {
    await controller.addLigne(projetId: 1, ordre: 0);
    await controller.addLigne(projetId: 1, ordre: 1);
    final lignes = await db.select(db.lignes).get();

    await controller.deleteLigne(id: lignes.first.id, projetId: 1);

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

    await controller.updateTimecode(
      id: ligne.id,
      projetId: 1,
      timecodeMs: 4200,
    );
    var updated = await (db.select(
      db.lignes,
    )..where((l) => l.id.equals(ligne.id))).getSingle();
    expect(updated.timecodeMs, 4200);

    await controller.updateTimecode(
      id: ligne.id,
      projetId: 1,
      timecodeMs: null,
    );
    updated = await (db.select(
      db.lignes,
    )..where((l) => l.id.equals(ligne.id))).getSingle();
    expect(updated.timecodeMs, isNull);
  });
}
