import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/projets_provider.dart';

const _availableLanguages = {'fr': 'French', 'en': 'English'};

class ProjectInfoScreen extends ConsumerStatefulWidget {
  const ProjectInfoScreen({required this.projetId, super.key});

  final int projetId;

  @override
  ConsumerState<ProjectInfoScreen> createState() => _ProjectInfoScreenState();
}

class _ProjectInfoScreenState extends ConsumerState<ProjectInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _language;
  bool _isSubmitting = false;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await ref
          .read(projetsControllerProvider)
          .update(
            id: widget.projetId,
            nom: _nameController.text.trim(),
            langue: _language!,
          );
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final projetAsync = ref.watch(projetProvider(widget.projetId));

    return Scaffold(
      appBar: AppBar(title: const Text('Project info')),
      body: projetAsync.when(
        data: (projet) {
          if (projet == null) {
            return const Center(child: Text('Project not found.'));
          }
          if (!_initialized) {
            _nameController.text = projet.nom;
            _language = projet.langueParDefaut;
            _initialized = true;
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Project name',
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Please enter a name'
                        : null,
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _language,
                    decoration: const InputDecoration(
                      labelText: 'Default language',
                    ),
                    items: _availableLanguages.entries
                        .map(
                          (entry) => DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _language = value);
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Something went wrong: $error')),
      ),
    );
  }
}
