import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.legalTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          _LegalSection(
            title: l10n.legalPublisherTitle,
            body: l10n.legalPublisherBody,
          ),
          _LegalSection(title: l10n.legalDataTitle, body: l10n.legalDataBody),
          _LegalSection(
            title: l10n.legalContentTitle,
            body: l10n.legalContentBody,
          ),
          _LegalSection(
            title: l10n.legalLicenseTitle,
            body: l10n.legalLicenseBody,
          ),
          _LegalSection(
            title: l10n.legalContactTitle,
            body: l10n.legalContactBody,
          ),
        ],
      ),
    );
  }
}

class _LegalSection extends StatelessWidget {
  const _LegalSection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(body),
        ],
      ),
    );
  }
}
