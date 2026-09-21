import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/l10n/app_localizations.dart';
import 'package:lyrics/ui/screens/donate_screen.dart';

void main() {
  testWidgets('shows both donation goals and the Buy Me a Coffee button', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const DonateScreen(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );

    expect(find.text('Support this project'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNWidgets(2));
    expect(find.text('Buy me a coffee'), findsOneWidget);
  });
}
