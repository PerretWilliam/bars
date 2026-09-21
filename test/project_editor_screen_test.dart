import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/providers/audio_provider.dart';
import 'package:lyrics/providers/database_provider.dart';
import 'package:lyrics/providers/lignes_provider.dart';
import 'package:lyrics/ui/screens/project_editor_screen.dart';

void main() {
  testWidgets('long-pressing the + FAB reveals the import-audio action', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioForProjetProvider(1).overrideWith((ref) => Stream.value(null)),
          lignesForProjetProvider(1)
              .overrideWith((ref) => Stream.value(<Ligne>[])),
        ],
        child: const MaterialApp(home: ProjectEditorScreen(projetId: 1)),
      ),
    );
    await tester.pump();

    expect(find.text('No lines yet. Tap + to start.'), findsOneWidget);
    expect(find.byTooltip('Import audio file'), findsNothing);

    await tester.longPress(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.byTooltip('Import audio file'), findsOneWidget);
  });

  testWidgets('typing digits auto-formats as mm:ss and persists it', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db
        .into(db.projets)
        .insert(ProjetsCompanion.insert(nom: 'Test project'));
    await db
        .into(db.lignes)
        .insert(LignesCompanion.insert(projetId: 1, texte: 'la', ordre: 0));
    final ligne = (await db.select(db.lignes).get()).single;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          audioForProjetProvider(1).overrideWith((ref) => Stream.value(null)),
          lignesForProjetProvider(1)
              .overrideWith((ref) => Stream.value([ligne])),
        ],
        child: const MaterialApp(home: ProjectEditorScreen(projetId: 1)),
      ),
    );
    await tester.pump();

    final timecodeField = find.byKey(ValueKey('timecode-${ligne.id}'));
    await tester.enterText(timecodeField, '1234');
    await tester.pump();

    expect(find.text('12:34'), findsOneWidget);

    // Tap elsewhere to defocus, which commits the value.
    await tester.tap(find.text('Notepad'));
    await tester.pump();

    final updated = await (db.select(
      db.lignes,
    )..where((l) => l.id.equals(ligne.id))).getSingle();
    expect(updated.timecodeMs, (12 * 60 + 34) * 1000);
  });
}
