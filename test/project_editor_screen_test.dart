import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/providers/audio_provider.dart';
import 'package:lyrics/providers/lignes_provider.dart';
import 'package:lyrics/ui/screens/project_editor_screen.dart';

void main() {
  testWidgets('the + button offers adding a line or importing audio', (
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

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Add line'), findsOneWidget);
    expect(find.text('Import audio file'), findsOneWidget);
  });
}
