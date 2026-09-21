import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/providers/audio_provider.dart';
import 'package:lyrics/providers/lignes_provider.dart';
import 'package:lyrics/ui/screens/rap_mode_screen.dart';
import 'package:wakelock_plus_platform_interface/wakelock_plus_platform_interface.dart';

class _FakeWakelockPlusPlatform extends WakelockPlusPlatformInterface {
  bool _enabled = false;

  @override
  Future<void> toggle({required bool enable}) async {
    _enabled = enable;
  }

  @override
  Future<bool> get enabled async => _enabled;
}

void main() {
  setUp(() {
    WakelockPlusPlatformInterface.instance = _FakeWakelockPlusPlatform();
  });

  final lignes = [
    Ligne(id: 1, projetId: 1, texte: 'First line', ordre: 0, timecodeMs: 0),
    Ligne(id: 2, projetId: 1, texte: 'Second line', ordre: 1, timecodeMs: 5000),
  ];

  testWidgets('renders lines read-only, without any editable field', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioForProjetProvider(1).overrideWith((ref) => Stream.value(null)),
          lignesForProjetProvider(1)
              .overrideWith((ref) => Stream.value(lignes)),
        ],
        child: const MaterialApp(home: RapModeScreen(projetId: 1)),
      ),
    );
    await tester.pump();

    expect(find.text('First line'), findsOneWidget);
    expect(find.text('Second line'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('font size controls change the rendered text size', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioForProjetProvider(1).overrideWith((ref) => Stream.value(null)),
          lignesForProjetProvider(1)
              .overrideWith((ref) => Stream.value(lignes)),
        ],
        child: const MaterialApp(home: RapModeScreen(projetId: 1)),
      ),
    );
    await tester.pump();

    Text textWidget() => tester.widget<Text>(find.text('First line'));

    final initialSize = textWidget().style!.fontSize!;

    await tester.tap(find.byIcon(Icons.text_increase));
    await tester.pump();

    expect(textWidget().style!.fontSize, greaterThan(initialSize));
  });

  testWidgets('tapping the sub-mode toggle switches auto and manual icons', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioForProjetProvider(1).overrideWith((ref) => Stream.value(null)),
          lignesForProjetProvider(1)
              .overrideWith((ref) => Stream.value(lignes)),
        ],
        child: const MaterialApp(home: RapModeScreen(projetId: 1)),
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.sync), findsOneWidget);
    expect(find.byIcon(Icons.pan_tool_alt_outlined), findsNothing);

    await tester.tap(find.byIcon(Icons.sync));
    await tester.pump();

    expect(find.byIcon(Icons.sync), findsNothing);
    expect(find.byIcon(Icons.pan_tool_alt_outlined), findsOneWidget);
  });

  testWidgets(
    'without an audio file, a play button drives a timer-based clock',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioForProjetProvider(1).overrideWith((ref) => Stream.value(null)),
            lignesForProjetProvider(1)
                .overrideWith((ref) => Stream.value(lignes)),
          ],
          child: const MaterialApp(home: RapModeScreen(projetId: 1)),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);

      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump();

      expect(find.byIcon(Icons.pause), findsOneWidget);

      await tester.tap(find.byIcon(Icons.pause));
      await tester.pump();

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    },
  );

  testWidgets(
    'the timer-based clock highlights the current line as it advances',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioForProjetProvider(1).overrideWith((ref) => Stream.value(null)),
            lignesForProjetProvider(1)
                .overrideWith((ref) => Stream.value(lignes)),
          ],
          child: const MaterialApp(home: RapModeScreen(projetId: 1)),
        ),
      );
      await tester.pump();

      Color? colorOf(String text) =>
          tester.widget<Text>(find.text(text)).style!.color;

      expect(colorOf('First line'), Colors.white38);
      expect(colorOf('Second line'), Colors.white38);

      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump(const Duration(milliseconds: 200));

      expect(colorOf('First line'), Colors.white);
      expect(colorOf('Second line'), Colors.white38);

      await tester.pump(const Duration(seconds: 5));

      expect(colorOf('First line'), Colors.white38);
      expect(colorOf('Second line'), Colors.white);

      await tester.tap(find.byIcon(Icons.pause));
      await tester.pump();
    },
  );
}
