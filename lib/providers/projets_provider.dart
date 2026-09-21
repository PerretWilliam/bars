import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_database.dart';
import 'database_provider.dart';

final projetsListProvider = StreamProvider<List<Projet>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.projets).watch();
});

final createProjetProvider =
    Provider<
      Future<void> Function({required String nom, required String langue})
    >((ref) {
      final db = ref.watch(databaseProvider);
      return ({required String nom, required String langue}) {
        return db
            .into(db.projets)
            .insert(
              ProjetsCompanion.insert(nom: nom, langueParDefaut: Value(langue)),
            );
      };
    });
