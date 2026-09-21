import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final _prodLinkController = TextEditingController();
  String? _language;
  bool _isSubmitting = false;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _prodLinkController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final lienProd = _prodLinkController.text.trim();
      await ref
          .read(projetsControllerProvider)
          .update(
            id: widget.projetId,
            nom: _nameController.text.trim(),
            langue: _language!,
            lienProd: lienProd.isEmpty ? null : lienProd,
          );
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _openProdLink() async {
    final url = Uri.tryParse(_prodLinkController.text.trim());
    if (url == null) return;
    await launchUrl(url, mode: LaunchMode.externalApplication);
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
            _prodLinkController.text = projet.lienProd ?? '';
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
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _prodLinkController,
                    decoration: InputDecoration(
                      labelText: 'Prod link (optional)',
                      hintText: 'https://…',
                      suffixIcon: IconButton(
                        icon: const Icon(LucideIcons.external_link),
                        tooltip: 'Open link',
                        onPressed: _openProdLink,
                      ),
                    ),
                    keyboardType: TextInputType.url,
                    validator: (value) {
                      final trimmed = value?.trim() ?? '';
                      if (trimmed.isEmpty) return null;
                      final uri = Uri.tryParse(trimmed);
                      return uri != null && uri.hasScheme
                          ? null
                          : 'Enter a valid URL';
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
