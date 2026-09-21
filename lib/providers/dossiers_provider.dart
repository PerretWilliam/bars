import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_database.dart';
import 'database_provider.dart';

final dossiersListProvider = StreamProvider<List<Dossier>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.dossiers).watch();
});

final dossierProvider = StreamProvider.family<Dossier?, int>((ref, id) {
  final db = ref.watch(databaseProvider);
  return (db.select(
    db.dossiers,
  )..where((row) => row.id.equals(id))).watchSingleOrNull();
});

class DossiersController {
  DossiersController(this._db);

  final AppDatabase _db;

  Future<int> create(String nom) {
    return _db.into(_db.dossiers).insert(DossiersCompanion.insert(nom: nom));
  }

  Future<void> rename(int id, String nom) {
    return (_db.update(_db.dossiers)..where((row) => row.id.equals(id))).write(
      DossiersCompanion(nom: Value(nom)),
    );
  }

  /// Deletes a folder. Its projects aren't deleted: the FK's `onDelete:
  /// setNull` clears their `dossierId`, so they fall back to the root list.
  Future<void> delete(int id) {
    return (_db.delete(_db.dossiers)..where((row) => row.id.equals(id))).go();
  }
}

final dossiersControllerProvider = Provider<DossiersController>((ref) {
  final db = ref.watch(databaseProvider);
  return DossiersController(db);
});
