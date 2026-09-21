import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lyrics/data/app_database.dart';
import 'package:lyrics/main.dart';
import 'package:lyrics/providers/projets_provider.dart';

void main() {
  testWidgets('shows empty state when there are no projects', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          projetsListProvider.overrideWith((ref) => Stream.value(<Projet>[])),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pump();

    expect(find.text('No projects yet'), findsOneWidget);
    expect(find.byIcon(LucideIcons.plus), findsOneWidget);
  });
}
