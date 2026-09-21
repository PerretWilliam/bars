import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/donation_config.dart';
import '../../l10n/app_localizations.dart';

const _buyMeACoffeeUrl = 'https://buymeacoffee.com/perretwilliam';

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appleRaised = DonationConfig.appleRaisedForCurrentCycle();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.donateTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.donateIntro),
          const SizedBox(height: 24),
          _GoalBar(
            label: l10n.googleGoalLabel,
            raised: DonationConfig.googleRaisedEuros,
            goal: DonationConfig.googleGoalEuros,
            amountLabel: l10n.donateAmountLabel(
              DonationConfig.googleRaisedEuros.toStringAsFixed(0),
              DonationConfig.googleGoalEuros.toStringAsFixed(0),
            ),
          ),
          const SizedBox(height: 20),
          _GoalBar(
            label: l10n.appleGoalLabel,
            raised: appleRaised,
            goal: DonationConfig.appleGoalEuros,
            amountLabel: l10n.donateAmountLabel(
              appleRaised.toStringAsFixed(0),
              DonationConfig.appleGoalEuros.toStringAsFixed(0),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: FilledButton.icon(
              onPressed: () => launchUrl(
                Uri.parse(_buyMeACoffeeUrl),
                mode: LaunchMode.externalApplication,
              ),
              icon: SvgPicture.asset(
                'assets/brand/buymeacoffee.svg',
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onPrimary,
                  BlendMode.srcIn,
                ),
              ),
              label: Text(l10n.buyMeACoffeeButtonLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalBar extends StatelessWidget {
  const _GoalBar({
    required this.label,
    required this.raised,
    required this.goal,
    required this.amountLabel,
  });

  final String label;
  final double raised;
  final double goal;
  final String amountLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (raised / goal).clamp(0, 1),
            minHeight: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(amountLabel, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
