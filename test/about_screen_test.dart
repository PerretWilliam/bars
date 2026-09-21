import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/l10n/app_localizations.dart';
import 'package:lyrics/ui/screens/about_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'Bars',
      packageName: 'com.williamperret.lyricsApp',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  testWidgets('shows the app name and links to the other info screens', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const AboutScreen(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bars'), findsOneWidget);
    expect(find.text('Version 1.0.0+1'), findsOneWidget);
    expect(find.text('Support this project'), findsOneWidget);
    expect(find.text('Changelog'), findsOneWidget);
    expect(find.text('Legal'), findsOneWidget);
    expect(find.text('Contributing'), findsOneWidget);
  });
}
