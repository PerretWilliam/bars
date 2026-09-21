import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/dictionaries_provider.dart';
import '../../services/dictionary_source.dart';

class DictionariesScreen extends ConsumerWidget {
  const DictionariesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rhyme dictionaries')),
      body: ListView(
        children: const [
          _DictionaryTile(
            language: DictionaryLanguage.fr,
            title: 'French (Lexique)',
          ),
          _DictionaryTile(
            language: DictionaryLanguage.en,
            title: 'English (CMU)',
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
    final importedAsync = ref.watch(
      dictionaryImportedProvider(widget.language),
    );
    final progress = _progress;

    String subtitle;
    if (progress != null && progress.phase != DictionaryImportPhase.done) {
      subtitle = switch (progress.phase) {
        DictionaryImportPhase.downloading =>
          progress.fraction != null
              ? 'Downloading… ${(progress.fraction! * 100).toStringAsFixed(0)}%'
              : 'Downloading…',
        DictionaryImportPhase.importing => 'Importing into the database…',
        DictionaryImportPhase.error => 'Failed: ${progress.errorMessage}',
        DictionaryImportPhase.done => '',
      };
    } else {
      subtitle = importedAsync.when(
        data: (imported) =>
            imported ? 'Downloaded — available offline' : 'Not downloaded',
        loading: () => 'Checking…',
        error: (error, stackTrace) => 'Something went wrong: $error',
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
              child: const Text('Download'),
            ),
    );
  }
}
