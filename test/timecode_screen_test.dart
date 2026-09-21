import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/providers/audio_provider.dart';
import 'package:lyrics/providers/lignes_provider.dart';
import 'package:lyrics/ui/screens/timecode_screen.dart';

void main() {
  testWidgets('shows the import button when no audio is loaded', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioForProjetProvider(1).overrideWith((ref) => Stream.value(null)),
          lignesForProjetProvider(1)
              .overrideWith((ref) => Stream.value(<Ligne>[])),
        ],
        child: const MaterialApp(home: TimecodeScreen(projetId: 1)),
      ),
    );
    await tester.pump();

    expect(find.text('Import audio file'), findsOneWidget);
  });
}
