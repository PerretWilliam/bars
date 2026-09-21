import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/l10n/app_localizations.dart';
import 'package:lyrics/providers/database_provider.dart';
import 'package:lyrics/providers/projets_provider.dart';
import 'package:lyrics/ui/screens/project_info_screen.dart';

void main() {
  testWidgets('pre-fills the form and saves edits', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final projetId = await db
        .into(db.projets)
        .insert(ProjetsCompanion.insert(nom: 'Old name'));
    final projet = await db.select(db.projets).getSingle();

    // context.pop() in ProjectInfoScreen needs a real GoRouter ancestor, not
    // just a MaterialApp/Navigator, so route through a minimal router.
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const Scaffold()),
        GoRoute(
          path: '/info',
          builder: (context, state) => ProjectInfoScreen(projetId: projetId),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          // A static override, not the real drift watch: a widget test
          // that disposes a real drift stream can leak a cleanup timer
          // into flutter_test's pending-timer check.
          projetProvider(projetId).overrideWith((ref) => Stream.value(projet)),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    router.push('/info');
    await tester.pumpAndSettle();

    expect(find.text('Old name'), findsOneWidget);
    expect(find.text('French'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'New name');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'https://example.com/beat',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final updated = await (db.select(
      db.projets,
    )..where((row) => row.id.equals(projetId))).getSingle();
    expect(updated.nom, 'New name');
    expect(updated.lienProd, 'https://example.com/beat');
  });
}
