import 'package:drift/drift.dart';

import '../data/app_database.dart';

/// Populates the database with sample projects and lines for manual
/// testing (simulator, dev builds). Does nothing if any project already
/// exists, so it never clobbers real data.
class DatabaseSeeder {
  DatabaseSeeder(this._db);

  final AppDatabase _db;

  Future<void> seedIfEmpty() async {
    final existingProjects = await _db.select(_db.projets).get();
    if (existingProjects.isNotEmpty) return;

    await _db.transaction(() async {
      await _seedProject(
        nom: 'Freestyle du dimanche',
        langue: 'fr',
        lignes: const [
          ("On monte les marches, un pas après l'autre", 0),
          ('Le son dans les oreilles, le monde en sourdine', 2500),
          ('Chaque ligne un souvenir, chaque rime une preuve', 5200),
          ("J'écris la nuit, le jour j'y crois encore", 8000),
          ('', null),
        ],
      );
      await _seedProject(
        nom: 'Untitled Track',
        langue: 'en',
        lignes: const [
          ("Started from the notebook, now it's on the page", 0),
          ('Every bar a building block, every hook a stage', 3000),
          ("No beat yet, just the words finding their place", null),
        ],
      );
    });
  }

  Future<void> _seedProject({
    required String nom,
    required String langue,
    required List<(String, int?)> lignes,
  }) async {
    final projetId = await _db
        .into(_db.projets)
        .insert(
          ProjetsCompanion.insert(nom: nom, langueParDefaut: Value(langue)),
        );

    for (var i = 0; i < lignes.length; i++) {
      final (texte, timecodeMs) = lignes[i];
      await _db
          .into(_db.lignes)
          .insert(
            LignesCompanion.insert(
              projetId: projetId,
              texte: texte,
              ordre: i,
              timecodeMs: Value(timecodeMs),
            ),
          );
    }
  }
}
