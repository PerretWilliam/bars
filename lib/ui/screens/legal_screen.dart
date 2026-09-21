import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.legalTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(l10n.legalPlaceholderText),
      ),
    );
  }
}
