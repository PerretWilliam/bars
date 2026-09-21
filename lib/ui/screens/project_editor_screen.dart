import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_database.dart';
import '../../providers/lignes_provider.dart';
import '../../services/language_detector.dart';
import '../widgets/rhyme_suggestions_panel.dart';

class ProjectEditorScreen extends ConsumerWidget {
  const ProjectEditorScreen({required this.projetId, super.key});

  final int projetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lignesAsync = ref.watch(lignesForProjetProvider(projetId));
    final controller = ref.read(lignesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notepad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_outlined),
            tooltip: 'Rhyme dictionaries',
            onPressed: () => context.push('/dictionaries'),
          ),
        ],
      ),
      body: lignesAsync.when(
        data: (lignes) {
          if (lignes.isEmpty) {
            return const Center(child: Text('No lines yet. Tap + to start.'));
          }
          return ReorderableListView.builder(
            itemCount: lignes.length,
            itemBuilder: (context, index) {
              final ligne = lignes[index];
              return _LigneTile(
                key: ValueKey(ligne.id),
                ligne: ligne,
                onDelete: () => controller.deleteLigne(ligne.id),
                onTexteChanged: (texte) =>
                    controller.updateTexte(ligne.id, texte),
                onLangueDetected: (langue) =>
                    controller.updateLangueDetectee(ligne.id, langue),
              );
            },
            onReorderItem: (index, newIndex) {
              final reordered = [...lignes];
              final moved = reordered.removeAt(index);
              reordered.insert(newIndex, moved);
              controller.reorder(reordered);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Something went wrong: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final lignes = lignesAsync.value ?? const [];
          controller.addLigne(projetId: projetId, ordre: lignes.length);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _LigneTile extends StatefulWidget {
  const _LigneTile({
    required super.key,
    required this.ligne,
    required this.onDelete,
    required this.onTexteChanged,
    required this.onLangueDetected,
  });

  final Ligne ligne;
  final VoidCallback onDelete;
  final ValueChanged<String> onTexteChanged;
  final ValueChanged<String?> onLangueDetected;

  @override
  State<_LigneTile> createState() => _LigneTileState();
}

final _wordPattern = RegExp(r"[a-zA-ZÀ-ÿ']+");

class _LigneTileState extends State<_LigneTile> {
  static const _detectionDebounce = Duration(milliseconds: 600);

  late final TextEditingController _textController;
  final _focusNode = FocusNode();
  Timer? _debounce;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.ligne.texte);
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTexteChanged(String texte) {
    widget.onTexteChanged(texte);
    // Recompute _lastWord immediately: waiting on the database round-trip
    // to trigger a rebuild would leave the rhyme panel a keystroke behind.
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(_detectionDebounce, () {
      widget.onLangueDetected(LanguageDetector.detect(texte));
    });
  }

  String? get _lastWord {
    final matches = _wordPattern.allMatches(_textController.text);
    if (matches.isEmpty) return null;
    return matches.last.group(0);
  }

  void _insertWord(String word) {
    final current = _textController.text;
    final separator = current.isEmpty || current.endsWith(' ') ? '' : ' ';
    final updated = '$current$separator$word';
    _textController.text = updated;
    _textController.selection = TextSelection.collapsed(offset: updated.length);
    widget.onTexteChanged(updated);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final lastWord = _lastWord;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: const Icon(Icons.drag_handle),
          title: TextField(
            controller: _textController,
            focusNode: _focusNode,
            decoration: const InputDecoration(border: InputBorder.none),
            onChanged: _onTexteChanged,
          ),
          subtitle: widget.ligne.langueDetectee == null
              ? null
              : Text(widget.ligne.langueDetectee!.toUpperCase()),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: widget.onDelete,
          ),
        ),
        if (_isFocused && lastWord != null)
          RhymeSuggestionsPanel(
            word: lastWord,
            langue: widget.ligne.langueDetectee ?? 'fr',
            onSelect: _insertWord,
          ),
      ],
    );
  }
}
