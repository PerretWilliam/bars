import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/services/project_bundle_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _FakePathProviderPlatform extends PathProviderPlatform {
  _FakePathProviderPlatform(this._path);

  final String _path;

  @override
  Future<String?> getApplicationDocumentsPath() async => _path;

  @override
  Future<String?> getTemporaryPath() async => _path;
}

void main() {
  late AppDatabase db;
  late ProjectBundleService service;
  late Directory scratchDir;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    service = ProjectBundleService(db);
    scratchDir = await Directory.systemTemp.createTemp('project_bundle_test');
    PathProviderPlatform.instance = _FakePathProviderPlatform(scratchDir.path);
  });

  tearDown(() async {
    await db.close();
    await scratchDir.delete(recursive: true);
  });

  test('round-trips a project with lines but no audio', () async {
    final projetId = await db
        .into(db.projets)
        .insert(ProjetsCompanion.insert(nom: 'Test project'));
    await db.batch(
      (batch) => batch.insertAll(db.lignes, [
        LignesCompanion.insert(
          projetId: projetId,
          texte: 'First line',
          ordre: 0,
          timecodeMs: const Value(1200),
        ),
        LignesCompanion.insert(
          projetId: projetId,
          texte: 'Second line',
          ordre: 1,
        ),
      ]),
    );

    final export = await service.exportProject(projetId);
    expect(export.fileName, 'Test project.rapproj');

    final zipFile = File('${scratchDir.path}/export.rapproj');
    await zipFile.writeAsBytes(export.bytes);
    final newProjetId = await service.importBundle(zipFile);

    expect(newProjetId, isNot(projetId));

    final newProjet = await (db.select(
      db.projets,
    )..where((p) => p.id.equals(newProjetId))).getSingle();
    expect(newProjet.nom, 'Test project');

    final newLignes =
        await (db.select(db.lignes)
              ..where((l) => l.projetId.equals(newProjetId))
              ..orderBy([(l) => OrderingTerm(expression: l.ordre)]))
            .get();
    expect(newLignes.map((l) => l.texte), ['First line', 'Second line']);
    expect(newLignes.first.timecodeMs, 1200);
    expect(newLignes.last.timecodeMs, isNull);
  });

  test('round-trips a project including its audio file', () async {
    final projetId = await db
        .into(db.projets)
        .insert(ProjetsCompanion.insert(nom: 'With audio'));
    final audioFile = File('${scratchDir.path}/source/audio.mp3');
    await audioFile.create(recursive: true);
    await audioFile.writeAsBytes([1, 2, 3, 4, 5]);
    await db
        .into(db.audios)
        .insert(
          AudiosCompanion.insert(
            projetId: projetId,
            cheminLocal: audioFile.path,
            dureeMs: 42000,
          ),
        );

    final export = await service.exportProject(projetId);
    final zipFile = File('${scratchDir.path}/export.rapproj');
    await zipFile.writeAsBytes(export.bytes);
    final newProjetId = await service.importBundle(zipFile);

    final newAudio = await (db.select(
      db.audios,
    )..where((a) => a.projetId.equals(newProjetId))).getSingle();
    expect(newAudio.dureeMs, 42000);
    expect(newAudio.cheminLocal, isNot(audioFile.path));
    expect(await File(newAudio.cheminLocal).readAsBytes(), [1, 2, 3, 4, 5]);
  });
}
