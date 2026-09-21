import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/providers/lignes_provider.dart';
import 'package:lyrics/providers/projets_provider.dart';
import 'package:lyrics/ui/screens/projects_list_screen.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

void main() {
  testWidgets('long-pressing the + FAB reveals the import-project action', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          projetsListProvider.overrideWith((ref) => Stream.value(<Projet>[])),
        ],
        child: const MaterialApp(home: ProjectsListScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('No projects yet'), findsOneWidget);
    expect(find.byTooltip('Import project'), findsNothing);

    await tester.longPress(find.byIcon(LucideIcons.plus));
    await tester.pump();

    expect(find.byTooltip('Import project'), findsOneWidget);
  });

  testWidgets(
    'a project card shows a language flag emoji in the title, not a badge',
    (tester) async {
      final projet = Projet(
        id: 1,
        nom: 'Freestyle',
        langueParDefaut: 'fr',
        createdAt: DateTime(2026),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projetsListProvider.overrideWith((ref) => Stream.value([projet])),
            lignesForProjetProvider(1)
                .overrideWith((ref) => Stream.value(<Ligne>[])),
          ],
          child: const MaterialApp(home: ProjectsListScreen()),
        ),
      );
      await tester.pump();

      expect(find.text('🇫🇷 Freestyle'), findsOneWidget);
      expect(find.text('FR'), findsNothing);
    },
  );
}
