import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/l10n/app_localizations.dart';
import 'package:lyrics/providers/dossiers_provider.dart';
import 'package:lyrics/providers/lignes_provider.dart';
import 'package:lyrics/providers/projets_provider.dart';
import 'package:lyrics/ui/screens/projects_list_screen.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

void main() {
  testWidgets('import is always available from the AppBar', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          projetsInDossierProvider(null)
              .overrideWith((ref) => Stream.value(<Projet>[])),
          dossiersListProvider.overrideWith((ref) => Stream.value(<Dossier>[])),
        ],
        child: MaterialApp(
          home: const ProjectsListScreen(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('No projects yet'), findsOneWidget);
    expect(find.byTooltip('Import project'), findsOneWidget);
  });

  testWidgets('long-pressing the + FAB reveals the new-folder action', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          projetsInDossierProvider(null)
              .overrideWith((ref) => Stream.value(<Projet>[])),
          dossiersListProvider.overrideWith((ref) => Stream.value(<Dossier>[])),
        ],
        child: MaterialApp(
          home: const ProjectsListScreen(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump();

    expect(find.byTooltip('New folder'), findsNothing);

    await tester.longPress(find.byIcon(LucideIcons.plus));
    await tester.pump();

    expect(find.byTooltip('New folder'), findsOneWidget);
  });

  testWidgets(
    'a project card shows a language flag emoji in the title, not a badge',
    (tester) async {
      final projet = Projet(
        id: 1,
        nom: 'Freestyle',
        langueParDefaut: 'fr',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projetsInDossierProvider(null)
                .overrideWith((ref) => Stream.value([projet])),
            dossiersListProvider.overrideWith(
              (ref) => Stream.value(<Dossier>[]),
            ),
            lignesForProjetProvider(1)
                .overrideWith((ref) => Stream.value(<Ligne>[])),
          ],
          child: MaterialApp(
            home: const ProjectsListScreen(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('🇫🇷 Freestyle'), findsOneWidget);
      expect(find.text('FR'), findsNothing);
    },
  );
}
