import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/l10n/app_localizations.dart';
import 'package:lyrics/ui/screens/changelog_screen.dart';

void main() {
  testWidgets('shows the current version entry', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const ChangelogScreen(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );

    expect(find.text('Changelog'), findsOneWidget);
    expect(find.textContaining('1.0.0'), findsOneWidget);
  });
}
