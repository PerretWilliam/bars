import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../data/app_database.dart';
import '../services/audio_file_manager.dart';
import 'database_provider.dart';
import 'projets_provider.dart';

/// The current playback position of whichever audio is loaded in the
/// Notepad screen. Read on-demand (not watched) so per-line "mark now"
/// actions can default to it without the lines list rebuilding on every
/// position tick.
class AudioPosition extends Notifier<Duration> {
  @override
  Duration build() => Duration.zero;

  void set(Duration position) => state = position;
}

final audioPositionProvider = NotifierProvider<AudioPosition, Duration>(
  AudioPosition.new,
);

/// A project has at most one active audio file: importing a new one
/// replaces the previous row.
final audioForProjetProvider = StreamProvider.family<Audio?, int>((
  ref,
  projetId,
) {
  final db = ref.watch(databaseProvider);
  return (db.select(
    db.audios,
  )..where((a) => a.projetId.equals(projetId))).watchSingleOrNull();
});

class AudioController {
  AudioController(this._db);

  final AppDatabase _db;
  final _fileManager = AudioFileManager();

  Future<void> importAudio(int projetId, String pickedPath) async {
    final copied = await _fileManager.copyIntoAppStorage(pickedPath);
    final player = AudioPlayer();
    Duration? duration;
    try {
      duration = await player.setFilePath(copied.path);
    } finally {
      await player.dispose();
    }

    await _db.transaction(() async {
      await (_db.delete(
        _db.audios,
      )..where((a) => a.projetId.equals(projetId))).go();
      await _db
          .into(_db.audios)
          .insert(
            AudiosCompanion.insert(
              projetId: projetId,
              cheminLocal: copied.path,
              dureeMs: duration?.inMilliseconds ?? 0,
            ),
          );
    });
    await touchProjet(_db, projetId);
  }

  Future<void> removeAudio(int projetId) async {
    await (_db.delete(
      _db.audios,
    )..where((a) => a.projetId.equals(projetId))).go();
    await touchProjet(_db, projetId);
  }
}

final audioControllerProvider = Provider<AudioController>((ref) {
  final db = ref.watch(databaseProvider);
  return AudioController(db);
});
