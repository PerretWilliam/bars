import 'package:go_router/go_router.dart';

import '../ui/screens/new_project_screen.dart';
import '../ui/screens/projects_list_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const ProjectsListScreen()),
    GoRoute(
      path: '/new',
      builder: (context, state) => const NewProjectScreen(),
    ),
  ],
);
