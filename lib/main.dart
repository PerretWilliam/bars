import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/database_provider.dart';
import 'router/app_router.dart';
import 'services/database_seeder.dart';
import 'services/language_detector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LanguageDetector.init();

  final container = ProviderContainer();
  if (kDebugMode) {
    await DatabaseSeeder(container.read(databaseProvider)).seedIfEmpty();
  }

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lyrics',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: appRouter,
    );
  }
}
