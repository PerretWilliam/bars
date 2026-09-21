import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_database.dart';
import '../../providers/projets_provider.dart';

class ProjectsListScreen extends ConsumerWidget {
  const ProjectsListScreen({super.key});

  Future<void> _importProject(BuildContext context, WidgetRef ref) async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['rapproj'],
    );
    if (files.isEmpty) return;
    final path = files.single.path;
    if (path == null) return;

    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Importing project…')));
    }
    await ref.read(projectBundleServiceProvider).importBundle(File(path));
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Projet projet,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete project?'),
        content: Text(
          'This permanently deletes "${projet.nom}", its lines, and its audio file.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(projetsControllerProvider).delete(projet.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projetsAsync = ref.watch(projetsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My projects')),
      body: projetsAsync.when(
        data: (projets) {
          if (projets.isEmpty) {
            return const _EmptyState();
          }
          return ListView.builder(
            itemCount: projets.length,
            itemBuilder: (context, index) {
              final projet = projets[index];
              return ListTile(
                title: Text(projet.nom),
                subtitle: Text(projet.langueParDefaut.toUpperCase()),
                onTap: () => context.push('/project/${projet.id}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete project',
                  onPressed: () => _confirmDelete(context, ref, projet),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Something went wrong: $error')),
      ),
      floatingActionButton: _NewProjectFab(
        onNewProject: () => context.push('/new'),
        onImportProject: () => _importProject(context, ref),
      ),
    );
  }
}

/// A `+` FAB that creates a new project on a plain tap; long-pressing
/// reveals a secondary mini-FAB for importing a `.rapproj` bundle.
class _NewProjectFab extends StatefulWidget {
  const _NewProjectFab({
    required this.onNewProject,
    required this.onImportProject,
  });

  final VoidCallback onNewProject;
  final VoidCallback onImportProject;

  @override
  State<_NewProjectFab> createState() => _NewProjectFabState();
}

class _NewProjectFabState extends State<_NewProjectFab> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_expanded)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FloatingActionButton.small(
              heroTag: 'importProjectFab',
              tooltip: 'Import project',
              onPressed: () {
                setState(() => _expanded = false);
                widget.onImportProject();
              },
              child: const Icon(Icons.file_open_outlined),
            ),
          ),
        GestureDetector(
          onLongPress: () => setState(() => _expanded = !_expanded),
          child: FloatingActionButton(
            heroTag: 'newProjectFab',
            onPressed: () {
              if (_expanded) {
                setState(() => _expanded = false);
              } else {
                widget.onNewProject();
              }
            },
            child: Icon(_expanded ? Icons.close : Icons.add),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.mic_none, size: 64),
            const SizedBox(height: 16),
            Text(
              'No projects yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the + button to start writing your first track.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
