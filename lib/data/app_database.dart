import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Projets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nom => text()();
  TextColumn get langueParDefaut => text().withDefault(const Constant('fr'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
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

@DriftDatabase(tables: [Projets, Lignes, Audios])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'lyrics_app');
}
