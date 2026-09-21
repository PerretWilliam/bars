import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/providers/database_provider.dart';
import 'package:lyrics/providers/rhymes_provider.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    await db.batch(
      (batch) => batch.insertAll(db.rhymes, [
        RhymesCompanion.insert(mot: 'maison', rimeKey: '§', langue: 'fr'),
        RhymesCompanion.insert(mot: 'chanson', rimeKey: '§', langue: 'fr'),
        RhymesCompanion.insert(mot: 'garcon', rimeKey: '§', langue: 'fr'),
      ]),
    );
  });

  tearDown(() {
    container.dispose();
    return db.close();
  });

  test('returns other words sharing the queried word\'s rime key', () async {
    final provider = rhymesForWordProvider((word: 'maison', langue: 'fr'));
    final subscription = container.listen(provider, (previous, next) {});
    addTearDown(subscription.close);

    final results = await container.read(provider.future);

    expect(results.map((r) => r.mot).toSet(), {'chanson', 'garcon'});
  });

  test('returns an empty list for a word not in the dictionary', () async {
    final provider = rhymesForWordProvider((word: 'zzz', langue: 'fr'));
    final subscription = container.listen(provider, (previous, next) {});
    addTearDown(subscription.close);

    final results = await container.read(provider.future);

    expect(results, isEmpty);
  });
}
