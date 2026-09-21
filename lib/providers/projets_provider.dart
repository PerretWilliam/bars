import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_database.dart';
import '../services/project_bundle_service.dart';
import 'database_provider.dart';

final projetsListProvider = StreamProvider<List<Projet>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.projets).watch();
});

class ProjetsController {
  ProjetsController(this._db);

  final AppDatabase _db;

  Future<void> create({required String nom, required String langue}) {
    return _db
        .into(_db.projets)
        .insert(
          ProjetsCompanion.insert(nom: nom, langueParDefaut: Value(langue)),
        );
  }

  /// Deletes a project's row (cascading its lines and audio row in the
  /// database) plus the audio file on disk, if one exists.
  Future<void> delete(int projetId) async {
    final audio = await (_db.select(
      _db.audios,
    )..where((row) => row.projetId.equals(projetId))).getSingleOrNull();
    if (audio != null) {
      final file = File(audio.cheminLocal);
      if (await file.exists()) await file.delete();
    }
    await (_db.delete(
      _db.projets,
    )..where((row) => row.id.equals(projetId))).go();
  }
}

final projetsControllerProvider = Provider<ProjetsController>((ref) {
  final db = ref.watch(databaseProvider);
  return ProjetsController(db);
});

final projectBundleServiceProvider = Provider<ProjectBundleService>((ref) {
  final db = ref.watch(databaseProvider);
  return ProjectBundleService(db);
});
