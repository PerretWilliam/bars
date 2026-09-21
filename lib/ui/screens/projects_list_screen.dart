import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/projets_provider.dart';

class ProjectsListScreen extends ConsumerWidget {
  const ProjectsListScreen({super.key});

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
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Something went wrong: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/new'),
        child: const Icon(Icons.add),
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
