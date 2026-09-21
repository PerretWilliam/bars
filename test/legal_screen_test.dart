import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/l10n/app_localizations.dart';
import 'package:lyrics/ui/screens/legal_screen.dart';

void main() {
  testWidgets('shows the legal sections', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const LegalScreen(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );

    expect(find.text('Legal'), findsOneWidget);
    expect(find.text('Publisher'), findsOneWidget);
    expect(find.text('Personal data'), findsOneWidget);
    expect(find.text('License'), findsOneWidget);
  });
}
