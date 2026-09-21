import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_database.dart';
import 'database_provider.dart';

/// A record so Riverpod's `family` compares queries structurally instead of
/// by identity — otherwise every rebuild would spawn a new provider instance
/// and tear down the previous one before it could resolve.
typedef RhymeQuery = ({String word, String langue});

const _maxSuggestions = 30;

/// Rhymes for the last word of a line: looks up that word's own rime key,
/// then returns other dictionary words sharing it.
final rhymesForWordProvider = StreamProvider.family<List<Rhyme>, RhymeQuery>((
  ref,
  query,
) async* {
  final db = ref.watch(databaseProvider);
  final word = query.word.toLowerCase();
  if (word.isEmpty) {
    yield const [];
    return;
  }

  final selfEntry =
      await (db.select(db.rhymes)
            ..where((r) => r.mot.equals(word) & r.langue.equals(query.langue))
            ..limit(1))
          .getSingleOrNull();

  if (selfEntry == null) {
    yield const [];
    return;
  }

  yield* (db.select(db.rhymes)
        ..where(
          (r) =>
              r.rimeKey.equals(selfEntry.rimeKey) &
              r.langue.equals(query.langue) &
              r.mot.equals(word).not(),
        )
        ..limit(_maxSuggestions))
      .watch();
});
