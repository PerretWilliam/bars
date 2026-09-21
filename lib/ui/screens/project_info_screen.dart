import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/dossiers_provider.dart';
import '../../providers/projets_provider.dart';

Map<String, String> _availableLanguages(AppLocalizations l10n) => {
  'fr': l10n.languageFrench,
  'en': l10n.languageEnglish,
};

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
  int? _dossierId;
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
            dossierId: _dossierId,
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
    final l10n = AppLocalizations.of(context)!;
    final projetAsync = ref.watch(projetProvider(widget.projetId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.projectInfoTitle)),
      body: projetAsync.when(
        data: (projet) {
          if (projet == null) {
            return Center(child: Text(l10n.projectNotFoundMessage));
          }
          if (!_initialized) {
            _nameController.text = projet.nom;
            _language = projet.langueParDefaut;
            _dossierId = projet.dossierId;
            _prodLinkController.text = projet.lienProd ?? '';
            _initialized = true;
          }
          final dossiersAsync = ref.watch(dossiersListProvider);
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.projectNameLabel,
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? l10n.projectNameRequiredError
                        : null,
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _language,
                    decoration: InputDecoration(
                      labelText: l10n.defaultLanguageLabel,
                    ),
                    items: _availableLanguages(l10n).entries
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
                  DropdownButtonFormField<int?>(
                    initialValue: _dossierId,
                    decoration: InputDecoration(labelText: l10n.folderLabel),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(l10n.noFolderOption),
                      ),
                      ...dossiersAsync.maybeWhen(
                        data: (dossiers) => dossiers.map(
                          (dossier) => DropdownMenuItem(
                            value: dossier.id,
                            child: Text(dossier.nom),
                          ),
                        ),
                        orElse: () =>
                            const Iterable<DropdownMenuItem<int?>>.empty(),
                      ),
                    ],
                    onChanged: (value) => setState(() => _dossierId = value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _prodLinkController,
                    decoration: InputDecoration(
                      labelText: l10n.prodLinkLabel,
                      hintText: l10n.prodLinkHint,
                      suffixIcon: IconButton(
                        icon: const Icon(LucideIcons.external_link),
                        tooltip: l10n.openLinkTooltip,
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
                          : l10n.invalidUrlError;
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
                        : Text(l10n.saveButton),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text(l10n.errorGenericMessage('$error'))),
      ),
    );
  }
}
