import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/l10n/app_localizations.dart';
import 'package:lyrics/providers/audio_provider.dart';
import 'package:lyrics/providers/lignes_provider.dart';
import 'package:lyrics/ui/screens/rap_mode_screen.dart';
import 'package:wakelock_plus_platform_interface/wakelock_plus_platform_interface.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

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

  Future<void> pumpRapMode(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioForProjetProvider(1).overrideWith((ref) => Stream.value(null)),
          lignesForProjetProvider(1)
              .overrideWith((ref) => Stream.value(lignes)),
        ],
        child: MaterialApp(
          home: RapModeScreen(projetId: 1),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();
  }

  AnimatedDefaultTextStyle styleOf(WidgetTester tester, String text) {
    return tester.widget<AnimatedDefaultTextStyle>(
      find
          .ancestor(
            of: find.text(text),
            matching: find.byType(AnimatedDefaultTextStyle),
          )
          .first,
    );
  }

  testWidgets('renders lines read-only, without any editable field', (
    tester,
  ) async {
    await pumpRapMode(tester);

    expect(find.text('First line'), findsOneWidget);
    expect(find.text('Second line'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('font size controls change the rendered text size', (
    tester,
  ) async {
    await pumpRapMode(tester);

    final initialSize = styleOf(tester, 'First line').style.fontSize!;

    await tester.tap(find.byIcon(LucideIcons.a_arrow_up));
    await tester.pump();

    expect(
      styleOf(tester, 'First line').style.fontSize,
      greaterThan(initialSize),
    );
  });

  testWidgets('tapping the sub-mode toggle switches auto and manual icons', (
    tester,
  ) async {
    await pumpRapMode(tester);

    expect(find.byIcon(LucideIcons.refresh_cw), findsOneWidget);
    expect(find.byIcon(LucideIcons.hand), findsNothing);

    await tester.tap(find.byIcon(LucideIcons.refresh_cw));
    await tester.pump();

    expect(find.byIcon(LucideIcons.refresh_cw), findsNothing);
    expect(find.byIcon(LucideIcons.hand), findsOneWidget);
  });

  testWidgets(
    'without an audio file, a play button drives a timer-based clock',
    (tester) async {
      await pumpRapMode(tester);

      expect(find.byIcon(LucideIcons.play), findsOneWidget);

      await tester.tap(find.byIcon(LucideIcons.play));
      await tester.pump();

      expect(find.byIcon(LucideIcons.pause), findsOneWidget);

      await tester.tap(find.byIcon(LucideIcons.pause));
      await tester.pump();

      expect(find.byIcon(LucideIcons.play), findsOneWidget);
    },
  );

  testWidgets(
    'the timer-based clock highlights the current line as it advances',
    (tester) async {
      await pumpRapMode(tester);

      expect(styleOf(tester, 'First line').style.color, Colors.white38);
      expect(styleOf(tester, 'Second line').style.color, Colors.white38);

      await tester.tap(find.byIcon(LucideIcons.play));
      await tester.pump(const Duration(milliseconds: 200));

      expect(styleOf(tester, 'First line').style.color, Colors.white);
      expect(styleOf(tester, 'Second line').style.color, Colors.white38);

      await tester.pump(const Duration(seconds: 5));

      expect(styleOf(tester, 'First line').style.color, Colors.white38);
      expect(styleOf(tester, 'Second line').style.color, Colors.white);

      // The clock already auto-paused on reaching the last timecode, so
      // there's no running timer left to clean up here.
      expect(find.byIcon(LucideIcons.play), findsOneWidget);
    },
  );

  testWidgets('tapping a line seeks the current line to its timecode', (
    tester,
  ) async {
    await pumpRapMode(tester);

    expect(styleOf(tester, 'First line').style.color, Colors.white38);

    await tester.tap(find.text('Second line'));
    await tester.pump();

    expect(styleOf(tester, 'First line').style.color, Colors.white38);
    expect(styleOf(tester, 'Second line').style.color, Colors.white);
  });

  testWidgets(
    'the timer-based clock auto-pauses on the last line without looping',
    (tester) async {
      await pumpRapMode(tester);

      await tester.tap(find.byIcon(LucideIcons.play));
      await tester.pump(const Duration(seconds: 6));

      expect(find.byIcon(LucideIcons.play), findsOneWidget);
      expect(styleOf(tester, 'Second line').style.color, Colors.white);
    },
  );

  testWidgets(
    'with looping enabled, the timer-based clock restarts instead of pausing',
    (tester) async {
      await pumpRapMode(tester);

      await tester.tap(find.byIcon(LucideIcons.repeat));
      await tester.pump();

      await tester.tap(find.byIcon(LucideIcons.play));
      await tester.pump(const Duration(seconds: 6));

      expect(find.byIcon(LucideIcons.pause), findsOneWidget);

      await tester.tap(find.byIcon(LucideIcons.pause));
      await tester.pump();
    },
  );
}
