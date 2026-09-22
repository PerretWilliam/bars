import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/dossiers_provider.dart';
import '../../providers/lignes_provider.dart';
import '../../providers/projets_provider.dart';

const _languageEmoji = {'fr': '🇫🇷', 'en': '🇬🇧'};

/// The common left/right content margin used across every screen, so the
/// projects list lines up with the AppBar's own inset instead of feeling
/// narrower or wider than it.
const pageHorizontalPadding = 16.0;

enum _OverflowAction { import, about }

class ProjectsListScreen extends ConsumerWidget {
  const ProjectsListScreen({this.dossierId, super.key});

  /// The folder being browsed, or null for the root (folder-less) list.
  final int? dossierId;

  Future<void> _importProject(BuildContext context, WidgetRef ref) async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['lrcproj'],
    );
    if (files.isEmpty) return;
    final path = files.single.path;
    if (path == null) return;

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.importingProjectMessage),
        ),
      );
    }
    await ref.read(projectBundleServiceProvider).importBundle(File(path));
  }

  Future<bool> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Projet projet,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteProjectDialogTitle),
        content: Text(l10n.deleteProjectDialogBody(projet.nom)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.deleteButton),
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

  Future<void> _createFolder(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final nom = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.newFolderDialogTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.folderNameLabel),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(l10n.createButton),
          ),
        ],
      ),
    );
    if (nom == null || nom.isEmpty) return;
    await ref.read(dossiersControllerProvider).create(nom);
  }

  Future<void> _renameFolder(
    BuildContext context,
    WidgetRef ref,
    Dossier dossier,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: dossier.nom);
    final nom = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.renameFolderDialogTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.folderNameLabel),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(l10n.saveButton),
          ),
        ],
      ),
    );
    if (nom == null || nom.isEmpty) return;
    await ref.read(dossiersControllerProvider).rename(dossier.id, nom);
  }

  Future<void> _deleteFolder(
    BuildContext context,
    WidgetRef ref,
    Dossier dossier,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteFolderDialogTitle),
        content: Text(l10n.deleteFolderDialogBody(dossier.nom)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(dossiersControllerProvider).delete(dossier.id);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final projetsAsync = ref.watch(projetsInDossierProvider(dossierId));
    final currentDossierId = dossierId;
    final dossier = currentDossierId == null
        ? null
        : ref.watch(dossierProvider(currentDossierId)).value;
    final foldersAsync = currentDossierId == null
        ? ref.watch(dossiersListProvider)
        : const AsyncValue<List<Dossier>>.data([]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentDossierId == null
              ? l10n.projectsListTitle
              : (dossier?.nom ?? ''),
        ),
        actions: [
          if (currentDossierId != null && dossier != null) ...[
            IconButton(
              icon: const Icon(LucideIcons.pencil),
              tooltip: l10n.renameFolderTooltip,
              onPressed: () => _renameFolder(context, ref, dossier),
            ),
            IconButton(
              icon: const Icon(LucideIcons.trash),
              tooltip: l10n.deleteFolderTooltip,
              onPressed: () => _deleteFolder(context, ref, dossier),
            ),
          ],
          PopupMenuButton<_OverflowAction>(
            tooltip: l10n.moreOptionsTooltip,
            onSelected: (action) {
              switch (action) {
                case _OverflowAction.import:
                  _importProject(context, ref);
                case _OverflowAction.about:
                  context.push('/about');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _OverflowAction.import,
                child: Row(
                  children: [
                    const Icon(LucideIcons.folder_open),
                    const SizedBox(width: 12),
                    Text(l10n.importProjectTooltip),
                  ],
                ),
              ),
              if (currentDossierId == null)
                PopupMenuItem(
                  value: _OverflowAction.about,
                  child: Row(
                    children: [
                      const Icon(LucideIcons.info),
                      const SizedBox(width: 12),
                      Text(l10n.aboutTooltip),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      body: projetsAsync.when(
        data: (projets) {
          final folders = foldersAsync.value ?? const <Dossier>[];
          if (projets.isEmpty && folders.isEmpty) {
            return const _EmptyState();
          }
          return Column(
            children: [
              if (folders.isNotEmpty) _FoldersRow(folders: folders),
              Expanded(
                child: _ProjectsListView(
                  projets: projets,
                  onDeleted: (projet) => _confirmDelete(context, ref, projet),
                  onExported: (projet) => _exportProject(context, ref, projet),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text(l10n.errorGenericMessage('$error'))),
      ),
      floatingActionButton: _NewProjectFab(
        onNewProject: () => context.push(
          currentDossierId == null
              ? '/new'
              : '/new?dossierId=$currentDossierId',
        ),
        onNewFolder: currentDossierId == null
            ? () => _createFolder(context, ref)
            : null,
      ),
    );
  }
}

class _FoldersRow extends StatelessWidget {
  const _FoldersRow({required this.folders});

  final List<Dossier> folders;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: pageHorizontalPadding),
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final dossier = folders[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              avatar: const Icon(LucideIcons.folder, size: 18),
              label: Text(dossier.nom),
              onPressed: () => context.push('/folder/${dossier.id}'),
            ),
          );
        },
      ),
    );
  }
}

typedef _ProjectAction = Future<void> Function(Projet projet);

class _ProjectsListView extends StatelessWidget {
  const _ProjectsListView({
    required this.projets,
    required this.onDeleted,
    required this.onExported,
  });

  final List<Projet> projets;
  final Future<bool> Function(Projet projet) onDeleted;
  final _ProjectAction onExported;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: projets.length,
      itemBuilder: (context, index) {
        final projet = projets[index];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: pageHorizontalPadding,
            vertical: 6,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Dismissible(
              key: ValueKey(projet.id),
              confirmDismiss: (direction) =>
                  direction == DismissDirection.endToStart
                  ? onDeleted(projet)
                  : onExported(projet).then((_) => false),
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
  }
}

/// A `+` FAB that creates a new project on a plain tap; long-pressing
/// reveals a secondary mini-FAB for creating a folder, when [onNewFolder]
/// is non-null (folders can't be nested, so this is hidden while already
/// browsing inside one).
class _NewProjectFab extends StatefulWidget {
  const _NewProjectFab({required this.onNewProject, this.onNewFolder});

  final VoidCallback onNewProject;
  final VoidCallback? onNewFolder;

  @override
  State<_NewProjectFab> createState() => _NewProjectFabState();
}

class _NewProjectFabState extends State<_NewProjectFab> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_expanded && widget.onNewFolder != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FloatingActionButton.small(
              heroTag: 'newFolderFab',
              tooltip: l10n.newFolderDialogTitle,
              onPressed: () {
                setState(() => _expanded = false);
                widget.onNewFolder!();
              },
              child: const Icon(LucideIcons.folder_plus),
            ),
          ),
        GestureDetector(
          onLongPress: widget.onNewFolder == null
              ? null
              : () => setState(() => _expanded = !_expanded),
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
    final l10n = AppLocalizations.of(context)!;
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
    final date = DateFormat.yMMMd(Localizations.localeOf(context).toString())
        .format(projet.updatedAt);

    return Card(
      elevation: 0,
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Row(
          children: [
            Expanded(
              child: Text(
                '${_languageEmoji[projet.langueParDefaut] ?? ''} ${projet.nom}',
                style: const TextStyle(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              date,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              preview ?? l10n.noLinesYetPreview,
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
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.mic, size: 64),
            const SizedBox(height: 16),
            Text(
              l10n.noProjectsYetTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(l10n.noProjectsYetBody, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
