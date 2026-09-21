import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../data/app_database.dart';
import '../models/project_bundle.dart';
import 'audio_file_manager.dart';

const _projectJsonEntry = 'project.json';

class ProjectExport {
  const ProjectExport({required this.bytes, required this.fileName});

  final Uint8List bytes;
  final String fileName;
}

class ProjectBundleService {
  ProjectBundleService(this._db);

  final AppDatabase _db;
  final _fileManager = AudioFileManager();

  Future<ProjectExport> exportProject(int projetId) async {
    final projet = await (_db.select(
      _db.projets,
    )..where((row) => row.id.equals(projetId))).getSingle();
    final lignes =
        await (_db.select(_db.lignes)
              ..where((row) => row.projetId.equals(projetId))
              ..orderBy([(row) => OrderingTerm(expression: row.ordre)]))
            .get();
    final audio = await (_db.select(
      _db.audios,
    )..where((row) => row.projetId.equals(projetId))).getSingleOrNull();

    final bundle = ProjectBundle(projet: projet, lignes: lignes, audio: audio);
    final archive = Archive();
    final jsonBytes = utf8.encode(jsonEncode(bundle.toJson()));
    archive.addFile(
      ArchiveFile(_projectJsonEntry, jsonBytes.length, jsonBytes),
    );

    if (audio != null) {
      final audioBytes = await File(audio.cheminLocal).readAsBytes();
      final audioEntryName = 'audio${p.extension(audio.cheminLocal)}';
      archive.addFile(
        ArchiveFile(audioEntryName, audioBytes.length, audioBytes),
      );
    }

    final zipBytes = ZipEncoder().encode(archive);
    final safeName = projet.nom
        .replaceAll(RegExp(r'[^A-Za-z0-9 _-]'), '')
        .trim();
    final fileName = '${safeName.isEmpty ? 'project' : safeName}.rapproj';

    return ProjectExport(
      bytes: Uint8List.fromList(zipBytes),
      fileName: fileName,
    );
  }

  Future<int> importBundle(File bundleFile) async {
    final bytes = await bundleFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final jsonEntry = archive.files.firstWhere(
      (file) => file.name == _projectJsonEntry,
    );
    final bundle = ProjectBundle.fromJson(
      jsonDecode(utf8.decode(jsonEntry.content)) as Map<String, dynamic>,
    );

    ArchiveFile? audioEntry;
    for (final file in archive.files) {
      if (file.name.startsWith('audio.')) {
        audioEntry = file;
        break;
      }
    }

    return _db.transaction(() async {
      final newProjetId = await _db
          .into(_db.projets)
          .insert(
            ProjetsCompanion(
              nom: Value(bundle.projet.nom),
              langueParDefaut: Value(bundle.projet.langueParDefaut),
              createdAt: Value(bundle.projet.createdAt),
            ),
          );

      for (final ligne in bundle.lignes) {
        await _db
            .into(_db.lignes)
            .insert(
              LignesCompanion.insert(
                projetId: newProjetId,
                texte: ligne.texte,
                ordre: ligne.ordre,
                langueDetectee: Value(ligne.langueDetectee),
                timecodeMs: Value(ligne.timecodeMs),
              ),
            );
      }

      final entry = audioEntry;
      if (entry != null && bundle.audio != null) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File(p.join(tempDir.path, entry.name));
        await tempFile.writeAsBytes(entry.content);
        final copied = await _fileManager.copyIntoAppStorage(tempFile.path);
        await tempFile.delete();

        await _db
            .into(_db.audios)
            .insert(
              AudiosCompanion.insert(
                projetId: newProjetId,
                cheminLocal: copied.path,
                dureeMs: bundle.audio!.dureeMs,
              ),
            );
      }

      return newProjetId;
    });
  }
}
