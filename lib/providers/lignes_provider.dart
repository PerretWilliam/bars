import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_database.dart';
import 'database_provider.dart';

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

  Future<void> addLigne({required int projetId, required int ordre}) {
    return _db
        .into(_db.lignes)
        .insert(
          LignesCompanion.insert(projetId: projetId, texte: '', ordre: ordre),
        );
  }

  Future<void> deleteLigne(int id) {
    return (_db.delete(_db.lignes)..where((l) => l.id.equals(id))).go();
  }

  Future<void> updateTexte(int id, String texte) {
    return (_db.update(_db.lignes)..where((l) => l.id.equals(id))).write(
      LignesCompanion(texte: Value(texte)),
    );
  }

  Future<void> updateLangueDetectee(int id, String? langue) {
    return (_db.update(_db.lignes)..where((l) => l.id.equals(id))).write(
      LignesCompanion(langueDetectee: Value(langue)),
    );
  }

  Future<void> updateTimecode(int id, int? timecodeMs) {
    return (_db.update(_db.lignes)..where((l) => l.id.equals(id))).write(
      LignesCompanion(timecodeMs: Value(timecodeMs)),
    );
  }

  Future<void> reorder(List<Ligne> lignesInNewOrder) {
    return _db.transaction(() async {
      for (var i = 0; i < lignesInNewOrder.length; i++) {
        final ligne = lignesInNewOrder[i];
        if (ligne.ordre == i) continue;
        await (_db.update(_db.lignes)..where((l) => l.id.equals(ligne.id)))
            .write(LignesCompanion(ordre: Value(i)));
      }
    });
  }
}

final lignesControllerProvider = Provider<LignesController>((ref) {
  final db = ref.watch(databaseProvider);
  return LignesController(db);
});
