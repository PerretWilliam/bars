import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/providers/audio_provider.dart';
import 'package:lyrics/providers/database_provider.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late AudioController controller;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    controller = AudioController(db);
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    await db
        .into(db.projets)
        .insert(ProjetsCompanion.insert(nom: 'Test project'));
  });

  tearDown(() {
    container.dispose();
    return db.close();
  });

  test('audioForProjetProvider emits null when no audio is imported', () async {
    final provider = audioForProjetProvider(1);
    final subscription = container.listen(provider, (previous, next) {});
    addTearDown(subscription.close);

    final result = await container.read(provider.future);

    expect(result, isNull);
  });

  test(
    'audioForProjetProvider emits the project\'s audio row once inserted',
    () async {
      await db
          .into(db.audios)
          .insert(
            AudiosCompanion.insert(
              projetId: 1,
              cheminLocal: '/tmp/audio.mp3',
              dureeMs: 60000,
            ),
          );

      final provider = audioForProjetProvider(1);
      final subscription = container.listen(provider, (previous, next) {});
      addTearDown(subscription.close);

      final result = await container.read(provider.future);

      expect(result?.cheminLocal, '/tmp/audio.mp3');
      expect(result?.dureeMs, 60000);
    },
  );

  test('removeAudio deletes the project\'s audio row', () async {
    await db
        .into(db.audios)
        .insert(
          AudiosCompanion.insert(
            projetId: 1,
            cheminLocal: '/tmp/audio.mp3',
            dureeMs: 60000,
          ),
        );

    await controller.removeAudio(1);

    final remaining = await db.select(db.audios).get();
    expect(remaining, isEmpty);
  });
}
