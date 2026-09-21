import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/providers/projets_provider.dart';

void main() {
  late AppDatabase db;
  late ProjetsController controller;
  late Directory scratchDir;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    controller = ProjetsController(db);
    scratchDir = await Directory.systemTemp.createTemp('projets_provider_test');
  });

  tearDown(() async {
    await db.close();
    await scratchDir.delete(recursive: true);
  });

  test('create inserts a project row', () async {
    await controller.create(nom: 'My project', langue: 'en');

    final projets = await db.select(db.projets).get();
    expect(projets.single.nom, 'My project');
    expect(projets.single.langueParDefaut, 'en');
  });

  test('delete removes the project, its lines, and its audio file', () async {
    final projetId = await db
        .into(db.projets)
        .insert(ProjetsCompanion.insert(nom: 'To delete'));
    await db
        .into(db.lignes)
        .insert(
          LignesCompanion.insert(projetId: projetId, texte: 'la', ordre: 0),
        );
    final audioFile = File('${scratchDir.path}/audio.mp3');
    await audioFile.writeAsBytes([1, 2, 3]);
    await db
        .into(db.audios)
        .insert(
          AudiosCompanion.insert(
            projetId: projetId,
            cheminLocal: audioFile.path,
            dureeMs: 1000,
          ),
        );

    await controller.delete(projetId);

    expect(await db.select(db.projets).get(), isEmpty);
    expect(await db.select(db.lignes).get(), isEmpty);
    expect(await db.select(db.audios).get(), isEmpty);
    expect(await audioFile.exists(), isFalse);
  });

  test('delete is a no-op when the audio file is already missing', () async {
    final projetId = await db
        .into(db.projets)
        .insert(ProjetsCompanion.insert(nom: 'Missing audio file'));
    await db
        .into(db.audios)
        .insert(
          AudiosCompanion.insert(
            projetId: projetId,
            cheminLocal: '${scratchDir.path}/does-not-exist.mp3',
            dureeMs: 1000,
          ),
        );

    await controller.delete(projetId);

    expect(await db.select(db.projets).get(), isEmpty);
  });
}
