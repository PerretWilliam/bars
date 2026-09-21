import 'package:go_router/go_router.dart';

import '../ui/screens/dictionaries_screen.dart';
import '../ui/screens/new_project_screen.dart';
import '../ui/screens/project_editor_screen.dart';
import '../ui/screens/projects_list_screen.dart';
import '../ui/screens/timecode_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ProjectsListScreen()),
    GoRoute(
      path: '/new',
      builder: (context, state) => const NewProjectScreen(),
    ),
    GoRoute(
      path: '/project/:id',
      builder: (context, state) =>
          ProjectEditorScreen(projetId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/dictionaries',
      builder: (context, state) => const DictionariesScreen(),
    ),
    GoRoute(
      path: '/project/:id/timecode',
      builder: (context, state) =>
          TimecodeScreen(projetId: int.parse(state.pathParameters['id']!)),
    ),
  ],
);
