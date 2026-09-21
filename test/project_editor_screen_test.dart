import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/providers/audio_provider.dart';
import 'package:lyrics/providers/database_provider.dart';
import 'package:lyrics/providers/lignes_provider.dart';
import 'package:lyrics/providers/projets_provider.dart';
import 'package:lyrics/ui/screens/project_editor_screen.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

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
          projetProvider(1).overrideWith((ref) => Stream.value(null)),
        ],
        child: const MaterialApp(home: ProjectEditorScreen(projetId: 1)),
      ),
    );
    await tester.pump();

    expect(find.text('No lines yet. Tap + to start.'), findsOneWidget);
    expect(find.byTooltip('Import audio file'), findsNothing);

    await tester.longPress(find.byIcon(LucideIcons.plus));
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
          projetProvider(1).overrideWith((ref) => Stream.value(null)),
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

  testWidgets('rejects a seconds part of 60 or more, e.g. 00:90', (
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
          projetProvider(1).overrideWith((ref) => Stream.value(null)),
        ],
        child: const MaterialApp(home: ProjectEditorScreen(projetId: 1)),
      ),
    );
    await tester.pump();

    final timecodeField = find.byKey(ValueKey('timecode-${ligne.id}'));
    await tester.enterText(timecodeField, '0090');
    await tester.pump();

    expect(find.text('00:90'), findsOneWidget);

    await tester.tap(find.text('Notepad'));
    await tester.pump();

    // Invalid input reverts the field instead of being persisted.
    expect(find.text('00:90'), findsNothing);
    final updated = await (db.select(
      db.lignes,
    )..where((l) => l.id.equals(ligne.id))).getSingle();
    expect(updated.timecodeMs, isNull);
  });

  testWidgets(
    'shows a warning when a line is earlier than the previous timecode',
    (tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final lignes = [
        Ligne(id: 1, projetId: 1, texte: 'First', ordre: 0, timecodeMs: 3000),
        Ligne(id: 2, projetId: 1, texte: 'Second', ordre: 1, timecodeMs: 0),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            audioForProjetProvider(1).overrideWith((ref) => Stream.value(null)),
            lignesForProjetProvider(1)
                .overrideWith((ref) => Stream.value(lignes)),
            projetProvider(1).overrideWith((ref) => Stream.value(null)),
          ],
          child: const MaterialApp(home: ProjectEditorScreen(projetId: 1)),
        ),
      );
      await tester.pump();

      expect(find.byIcon(LucideIcons.triangle_alert), findsOneWidget);
    },
  );

  testWidgets('the timecode toggle hides and shows the timecode column', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final lignes = [
      Ligne(id: 1, projetId: 1, texte: 'First', ordre: 0, timecodeMs: 0),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          audioForProjetProvider(1).overrideWith((ref) => Stream.value(null)),
          lignesForProjetProvider(1)
              .overrideWith((ref) => Stream.value(lignes)),
          projetProvider(1).overrideWith((ref) => Stream.value(null)),
        ],
        child: const MaterialApp(home: ProjectEditorScreen(projetId: 1)),
      ),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('timecode-1')), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.eye));
    await tester.pump();

    expect(find.byKey(const ValueKey('timecode-1')), findsNothing);
  });

  testWidgets('swiping a line right deletes it', (tester) async {
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
          projetProvider(1).overrideWith((ref) => Stream.value(null)),
        ],
        child: const MaterialApp(home: ProjectEditorScreen(projetId: 1)),
      ),
    );
    await tester.pump();

    // Drag from blank space at the tile's left edge, not the drag-handle
    // icon (that starts a reorder) and not the TextField (a plain
    // horizontal drag there is claimed by its own text-selection gesture
    // before it reaches the Dismissible).
    //
    // Bounded pumps instead of pumpAndSettle: the overridden lignes stream
    // here is static (doesn't shrink after the delete), so there's no
    // frame the tree is guaranteed to settle on.
    final tileRect = tester.getRect(find.byType(Dismissible));
    final dragStart = Offset(tileRect.left + 2, tileRect.center.dy);
    await tester.dragFrom(dragStart, const Offset(500, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(await db.select(db.lignes).get(), isEmpty);
  });

  testWidgets(
    'the + FAB only shows "Open prod" when the project has a prod link',
    (tester) async {
      final projet = Projet(
        id: 1,
        nom: 'Test project',
        langueParDefaut: 'fr',
        createdAt: DateTime(2026),
        lienProd: 'https://example.com/beat',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioForProjetProvider(1).overrideWith((ref) => Stream.value(null)),
            lignesForProjetProvider(1)
                .overrideWith((ref) => Stream.value(<Ligne>[])),
            projetProvider(1).overrideWith((ref) => Stream.value(projet)),
          ],
          child: const MaterialApp(home: ProjectEditorScreen(projetId: 1)),
        ),
      );
      await tester.pump();

      await tester.longPress(find.byIcon(LucideIcons.plus));
      await tester.pump();

      expect(find.byTooltip('Open prod'), findsOneWidget);
    },
  );

  testWidgets('the + FAB hides "Open prod" when the project has no prod link', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioForProjetProvider(1).overrideWith((ref) => Stream.value(null)),
          lignesForProjetProvider(1)
              .overrideWith((ref) => Stream.value(<Ligne>[])),
          projetProvider(1).overrideWith((ref) => Stream.value(null)),
        ],
        child: const MaterialApp(home: ProjectEditorScreen(projetId: 1)),
      ),
    );
    await tester.pump();

    await tester.longPress(find.byIcon(LucideIcons.plus));
    await tester.pump();

    expect(find.byTooltip('Open prod'), findsNothing);
  });
}
