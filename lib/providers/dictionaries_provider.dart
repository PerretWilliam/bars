import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_database.dart';
import '../services/dictionary_downloader.dart';
import '../services/dictionary_source.dart';
import '../services/rhyme_dictionary_importer.dart';
import 'database_provider.dart';

enum DictionaryImportPhase { downloading, importing, done, error }

class DictionaryImportProgress {
  const DictionaryImportProgress({
    required this.phase,
    this.fraction,
    this.wordCount,
    this.errorMessage,
  });

  final DictionaryImportPhase phase;
  final double? fraction;
  final int? wordCount;
  final String? errorMessage;
}

/// Whether a language's rhyme dictionary has already been imported into the
/// local database (i.e. it is usable fully offline).
final dictionaryImportedProvider =
    StreamProvider.family<bool, DictionaryLanguage>((ref, language) {
      final db = ref.watch(databaseProvider);
      final countExpression = db.rhymes.id.count();
      final query = db.selectOnly(db.rhymes)
        ..addColumns([countExpression])
        ..where(db.rhymes.langue.equals(language.name));
      return query.watchSingle().map(
        (row) => (row.read(countExpression) ?? 0) > 0,
      );
    });

class DictionaryImporterService {
  DictionaryImporterService(this._db);

  final _downloader = DictionaryDownloader();
  final AppDatabase _db;

  Stream<DictionaryImportProgress> import(DictionaryLanguage language) {
    final controller = StreamController<DictionaryImportProgress>();
    unawaited(_run(language, controller));
    return controller.stream;
  }

  Future<void> _run(
    DictionaryLanguage language,
    StreamController<DictionaryImportProgress> controller,
  ) async {
    try {
      final source = dictionarySources[language]!;
      controller.add(
        const DictionaryImportProgress(
          phase: DictionaryImportPhase.downloading,
          fraction: 0,
        ),
      );
      final file = await _downloader.ensureDownloaded(
        source,
        onProgress: (received, total) {
          final fraction = (total != null && total > 0)
              ? received / total
              : null;
          controller.add(
            DictionaryImportProgress(
              phase: DictionaryImportPhase.downloading,
              fraction: fraction,
            ),
          );
        },
      );

      controller.add(
        const DictionaryImportProgress(phase: DictionaryImportPhase.importing),
      );
      final importer = RhymeDictionaryImporter(_db);
      final count = language == DictionaryLanguage.fr
          ? await importer.importFrench(file)
          : await importer.importEnglish(file);

      controller.add(
        DictionaryImportProgress(
          phase: DictionaryImportPhase.done,
          fraction: 1,
          wordCount: count,
        ),
      );
    } catch (e) {
      controller.add(
        DictionaryImportProgress(
          phase: DictionaryImportPhase.error,
          errorMessage: e.toString(),
        ),
      );
    } finally {
      await controller.close();
    }
  }
}

final dictionaryImporterProvider = Provider<DictionaryImporterService>((ref) {
  final db = ref.watch(databaseProvider);
  return DictionaryImporterService(db);
});
