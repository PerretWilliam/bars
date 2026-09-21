import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_database.dart';
import '../../providers/lignes_provider.dart';
import '../../providers/projets_provider.dart';

const _languageEmoji = {'fr': '🇫🇷', 'en': '🇬🇧'};

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

  Future<bool> _confirmDelete(
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
    if (confirmed != true) return false;
    await ref.read(projetsControllerProvider).delete(projet.id);
    return true;
  }

  Future<void> _exportProject(
    BuildContext context,
    WidgetRef ref,
    Projet projet,
  ) async {
    final export = await ref
        .read(projectBundleServiceProvider)
        .exportProject(projet.id);
    await FilePicker.saveFile(fileName: export.fileName, bytes: export.bytes);
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
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: projets.length,
            itemBuilder: (context, index) {
              final projet = projets[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Dismissible(
                    key: ValueKey(projet.id),
                    confirmDismiss: (direction) =>
                        direction == DismissDirection.endToStart
                        ? _confirmDelete(context, ref, projet)
                        : _exportProject(
                            context,
                            ref,
                            projet,
                          ).then((_) => false),
                    background: const _SwipeBackground(
                      color: Colors.green,
                      icon: LucideIcons.share_2,
                      alignment: Alignment.centerLeft,
                    ),
                    secondaryBackground: const _SwipeBackground(
                      color: Colors.red,
                      icon: LucideIcons.trash,
                      alignment: Alignment.centerRight,
                    ),
                    child: _ProjectCard(
                      projet: projet,
                      onTap: () => context.push('/project/${projet.id}'),
                    ),
                  ),
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
              child: const Icon(LucideIcons.folder_open),
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
            child: Icon(_expanded ? LucideIcons.x : LucideIcons.plus),
          ),
        ),
      ],
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.color,
    required this.icon,
    required this.alignment,
  });

  final Color color;
  final IconData icon;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _ProjectCard extends ConsumerWidget {
  const _ProjectCard({required this.projet, required this.onTap});

  final Projet projet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final lignesAsync = ref.watch(lignesForProjetProvider(projet.id));
    final preview = lignesAsync.maybeWhen(
      data: (lignes) {
        final texts = lignes
            .map((l) => l.texte.trim())
            .where((t) => t.isNotEmpty)
            .toList();
        return texts.isEmpty ? null : texts.join('  ·  ');
      },
      orElse: () => null,
    );

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHigh,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          '${_languageEmoji[projet.langueParDefaut] ?? ''} ${projet.nom}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              preview ?? 'No lines yet',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant.withValues(
                  alpha: preview == null ? 0.6 : 1,
                ),
                fontStyle: preview == null
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
            ),
          ],
        ),
        trailing: const Icon(LucideIcons.chevron_right),
        onTap: onTap,
      ),
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
            const Icon(LucideIcons.mic, size: 64),
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
