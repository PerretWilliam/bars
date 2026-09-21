import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/providers/projets_provider.dart';
import 'package:lyrics/ui/screens/projects_list_screen.dart';

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

    await tester.longPress(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.byTooltip('Import project'), findsOneWidget);
  });
}
