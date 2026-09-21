import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ProjectsViewMode { list, grid }

class ProjectsViewModeNotifier extends Notifier<ProjectsViewMode> {
  @override
  ProjectsViewMode build() => ProjectsViewMode.list;

  void toggle() => state = state == ProjectsViewMode.list
      ? ProjectsViewMode.grid
      : ProjectsViewMode.list;
}

final projectsViewModeProvider =
    NotifierProvider<ProjectsViewModeNotifier, ProjectsViewMode>(
      ProjectsViewModeNotifier.new,
    );
