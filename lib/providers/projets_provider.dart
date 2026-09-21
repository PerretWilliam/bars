import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_database.dart';
import '../services/project_bundle_service.dart';
import 'database_provider.dart';

final projetProvider = StreamProvider.family<Projet?, int>((ref, projetId) {
  final db = ref.watch(databaseProvider);
  return (db.select(
    db.projets,
  )..where((row) => row.id.equals(projetId))).watchSingleOrNull();
});

/// Projects belonging to [dossierId], or the root-level (folder-less)
/// projects when [dossierId] is null.
final projetsInDossierProvider = StreamProvider.family<List<Projet>, int?>((
  ref,
  dossierId,
) {
  final db = ref.watch(databaseProvider);
  final query = db.select(db.projets);
  if (dossierId == null) {
    query.where((row) => row.dossierId.isNull());
  } else {
    query.where((row) => row.dossierId.equals(dossierId));
  }
  return query.watch();
});

/// Bumps a project's `updatedAt` to now. Called by any controller that
/// mutates a project or something that belongs to it (lines, audio), so
/// the project list can show a "last modified" date.
Future<void> touchProjet(AppDatabase db, int projetId) {
  return (db.update(db.projets)..where((row) => row.id.equals(projetId))).write(
    ProjetsCompanion(updatedAt: Value(DateTime.now())),
  );
}

class ProjetsController {
  ProjetsController(this._db);

  final AppDatabase _db;

  Future<void> create({
    required String nom,
    required String langue,
    int? dossierId,
  }) {
    return _db
        .into(_db.projets)
        .insert(
          ProjetsCompanion.insert(
            nom: nom,
            langueParDefaut: Value(langue),
            dossierId: Value(dossierId),
          ),
        );
  }

  Future<void> update({
    required int id,
    required String nom,
    required String langue,
    String? lienProd,
    int? dossierId,
  }) {
    return (_db.update(_db.projets)..where((row) => row.id.equals(id))).write(
      ProjetsCompanion(
        nom: Value(nom),
        langueParDefaut: Value(langue),
        lienProd: Value(lienProd),
        dossierId: Value(dossierId),
        updatedAt: Value(DateTime.now()),
      ),
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
