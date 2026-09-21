import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_database.dart';
import 'database_provider.dart';
import 'projets_provider.dart';

final lignesForProjetProvider = StreamProvider.family<List<Ligne>, int>((
  ref,
  projetId,
) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.lignes)
        ..where((l) => l.projetId.equals(projetId))
        ..orderBy([(l) => OrderingTerm(expression: l.ordre)]))
      .watch();
});

class LignesController {
  LignesController(this._db);

  final AppDatabase _db;

  Future<void> addLigne({required int projetId, required int ordre}) async {
    await _db
        .into(_db.lignes)
        .insert(
          LignesCompanion.insert(projetId: projetId, texte: '', ordre: ordre),
        );
    await touchProjet(_db, projetId);
  }

  Future<void> deleteLigne({required int id, required int projetId}) async {
    await (_db.delete(_db.lignes)..where((l) => l.id.equals(id))).go();
    await touchProjet(_db, projetId);
  }

  Future<void> updateTexte({
    required int id,
    required int projetId,
    required String texte,
  }) async {
    await (_db.update(_db.lignes)..where((l) => l.id.equals(id))).write(
      LignesCompanion(texte: Value(texte)),
    );
    await touchProjet(_db, projetId);
  }

  Future<void> updateLangueDetectee({
    required int id,
    required int projetId,
    required String? langue,
  }) async {
    await (_db.update(_db.lignes)..where((l) => l.id.equals(id))).write(
      LignesCompanion(langueDetectee: Value(langue)),
    );
    await touchProjet(_db, projetId);
  }

  Future<void> updateTimecode({
    required int id,
    required int projetId,
    required int? timecodeMs,
  }) async {
    await (_db.update(_db.lignes)..where((l) => l.id.equals(id))).write(
      LignesCompanion(timecodeMs: Value(timecodeMs)),
    );
    await touchProjet(_db, projetId);
  }

  Future<void> reorder(List<Ligne> lignesInNewOrder) async {
    await _db.transaction(() async {
      for (var i = 0; i < lignesInNewOrder.length; i++) {
        final ligne = lignesInNewOrder[i];
        if (ligne.ordre == i) continue;
        await (_db.update(_db.lignes)..where((l) => l.id.equals(ligne.id)))
            .write(LignesCompanion(ordre: Value(i)));
      }
    });
    if (lignesInNewOrder.isNotEmpty) {
      await touchProjet(_db, lignesInNewOrder.first.projetId);
    }
  }
}

final lignesControllerProvider = Provider<LignesController>((ref) {
  final db = ref.watch(databaseProvider);
  return LignesController(db);
});
