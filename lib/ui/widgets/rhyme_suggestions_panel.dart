import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/rhymes_provider.dart';

class RhymeSuggestionsPanel extends ConsumerWidget {
  const RhymeSuggestionsPanel({
    required this.word,
    required this.langue,
    required this.onSelect,
    super.key,
  });

  final String word;
  final String langue;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final rhymesAsync = ref.watch(
      rhymesForWordProvider((word: word, langue: langue)),
    );

    return SizedBox(
      height: 56,
      child: rhymesAsync.when(
        data: (rhymes) {
          if (rhymes.isEmpty) {
            return Center(child: Text(l10n.noRhymesFoundMessage));
          }
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: rhymes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final rhyme = rhymes[index];
              return ActionChip(
                label: Text(rhyme.mot),
                onPressed: () => onSelect(rhyme.mot),
              );
            },
          );
        },
        loading: () => const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        error: (error, stackTrace) =>
            Center(child: Text(l10n.errorGenericMessage('$error'))),
      ),
    );
  }
}
