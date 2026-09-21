import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Projets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nom => text()();
  TextColumn get langueParDefaut => text().withDefault(const Constant('fr'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get lienProd => text().nullable()();
}

class Lignes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projetId =>
      integer().references(Projets, #id, onDelete: KeyAction.cascade)();
  TextColumn get texte => text()();
  IntColumn get ordre => integer()();
  TextColumn get langueDetectee => text().nullable()();
  IntColumn get timecodeMs => integer().nullable()();
}

class Audios extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projetId =>
      integer().references(Projets, #id, onDelete: KeyAction.cascade)();
  TextColumn get cheminLocal => text()();
  IntColumn get dureeMs => integer()();
}

@TableIndex(name: 'idx_rhymes_mot', columns: {#mot})
@TableIndex(name: 'idx_rhymes_rime_key', columns: {#rimeKey, #langue})
class Rhymes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get mot => text()();
  TextColumn get rimeKey => text()();
  TextColumn get langue => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {mot, rimeKey, langue},
  ];
}

@DriftDatabase(tables: [Projets, Lignes, Audios, Rhymes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.connection);

  // Rhymes queries filter by mot or by (rimeKey, langue) against a
  // 100k+ row table; without indices those scans are slow enough to lose
  // the race with Riverpod's default provider auto-disposal.
  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(rhymes);
      }
      if (from < 3) {
        await m.createIndex(idxRhymesMot);
        await m.createIndex(idxRhymesRimeKey);
      }
      if (from < 4) {
        await m.addColumn(projets, projets.lienProd);
      }
    },
    // SQLite ignores declared `onDelete: KeyAction.cascade` foreign keys
    // unless this pragma is set per-connection.
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'lyrics_app');
}
