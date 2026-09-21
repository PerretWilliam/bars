import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/dictionaries_provider.dart';
import '../../services/dictionary_source.dart';

class DictionariesScreen extends ConsumerWidget {
  const DictionariesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.rhymeDictionariesTitle)),
      body: ListView(
        children: [
          _DictionaryTile(
            language: DictionaryLanguage.fr,
            title: l10n.frenchDictionaryTitle,
          ),
          _DictionaryTile(
            language: DictionaryLanguage.en,
            title: l10n.englishDictionaryTitle,
          ),
        ],
      ),
    );
  }
}

class _DictionaryTile extends ConsumerStatefulWidget {
  const _DictionaryTile({required this.language, required this.title});

  final DictionaryLanguage language;
  final String title;

  @override
  ConsumerState<_DictionaryTile> createState() => _DictionaryTileState();
}

class _DictionaryTileState extends ConsumerState<_DictionaryTile> {
  DictionaryImportProgress? _progress;

  void _startImport() {
    final importer = ref.read(dictionaryImporterProvider);
    importer.import(widget.language).listen((progress) {
      if (mounted) setState(() => _progress = progress);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final importedAsync = ref.watch(
      dictionaryImportedProvider(widget.language),
    );
    final progress = _progress;

    String subtitle;
    if (progress != null && progress.phase != DictionaryImportPhase.done) {
      subtitle = switch (progress.phase) {
        DictionaryImportPhase.downloading =>
          progress.fraction != null
              ? l10n.dictionaryDownloadingProgressMessage(
                  (progress.fraction! * 100).round(),
                )
              : l10n.dictionaryDownloadingMessage,
        DictionaryImportPhase.importing => l10n.dictionaryImportingMessage,
        DictionaryImportPhase.error => l10n.dictionaryFailedMessage(
          '${progress.errorMessage}',
        ),
        DictionaryImportPhase.done => '',
      };
    } else {
      subtitle = importedAsync.when(
        data: (imported) => imported
            ? l10n.dictionaryDownloadedMessage
            : l10n.dictionaryNotDownloadedMessage,
        loading: () => l10n.dictionaryCheckingMessage,
        error: (error, stackTrace) => l10n.errorGenericMessage('$error'),
      );
    }

    final isBusy =
        progress != null &&
        (progress.phase == DictionaryImportPhase.downloading ||
            progress.phase == DictionaryImportPhase.importing);

    return ListTile(
      title: Text(widget.title),
      subtitle: Text(subtitle),
      trailing: isBusy
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : FilledButton(
              onPressed: _startImport,
              child: Text(l10n.downloadButton),
            ),
    );
  }
}
