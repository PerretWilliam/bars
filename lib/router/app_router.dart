import 'package:go_router/go_router.dart';

import '../ui/screens/about_screen.dart';
import '../ui/screens/changelog_screen.dart';
import '../ui/screens/dictionaries_screen.dart';
import '../ui/screens/donate_screen.dart';
import '../ui/screens/legal_screen.dart';
import '../ui/screens/new_project_screen.dart';
import '../ui/screens/project_editor_screen.dart';
import '../ui/screens/project_info_screen.dart';
import '../ui/screens/projects_list_screen.dart';
import '../ui/screens/rap_mode_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ProjectsListScreen()),
    GoRoute(
      path: '/folder/:id',
      builder: (context, state) =>
          ProjectsListScreen(dossierId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/new',
      builder: (context, state) => NewProjectScreen(
        dossierId: int.tryParse(state.uri.queryParameters['dossierId'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/project/:id',
      builder: (context, state) =>
          ProjectEditorScreen(projetId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/project/:id/rap',
      builder: (context, state) =>
          RapModeScreen(projetId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/project/:id/info',
      builder: (context, state) =>
          ProjectInfoScreen(projetId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/dictionaries',
      builder: (context, state) => const DictionariesScreen(),
    ),
    GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
    GoRoute(path: '/legal', builder: (context, state) => const LegalScreen()),
    GoRoute(
      path: '/changelog',
      builder: (context, state) => const ChangelogScreen(),
    ),
    GoRoute(path: '/donate', builder: (context, state) => const DonateScreen()),
  ],
);
