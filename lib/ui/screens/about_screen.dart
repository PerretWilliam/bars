import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';

/// An IconButton-sized brand logo, tinted to match the icon theme so it
/// still adapts to light/dark like the surrounding Lucide icons.
class _BrandIconButton extends StatelessWidget {
  const _BrandIconButton({
    required this.assetPath,
    required this.tooltip,
    required this.onPressed,
  });

  final String assetPath;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        assetPath,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          IconTheme.of(context).color!,
          BlendMode.srcIn,
        ),
      ),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}

const _authorWebsiteUrl = 'https://william-perret.fr';
const _githubUrl = 'https://github.com/PerretWilliam/bars';
const _buyMeACoffeeUrl = 'https://buymeacoffee.com/perretwilliam';
const _contributingUrl =
    'https://github.com/PerretWilliam/bars/blob/main/CONTRIBUTING.md';

Future<void> _openUrl(String url) =>
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/icon/icon.png',
                    width: 96,
                    height: 96,
                  ),
                ),
                const SizedBox(height: 12),
                Text('Bars', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final info = snapshot.data;
                    if (info == null) return const SizedBox.shrink();
                    return Text(
                      l10n.appVersionLabel(
                        '${info.version}+${info.buildNumber}',
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.aboutTagline,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.globe),
                      tooltip: l10n.authorWebsiteTooltip,
                      onPressed: () => _openUrl(_authorWebsiteUrl),
                    ),
                    _BrandIconButton(
                      assetPath: 'assets/brand/github.svg',
                      tooltip: l10n.githubTooltip,
                      onPressed: () => _openUrl(_githubUrl),
                    ),
                    _BrandIconButton(
                      assetPath: 'assets/brand/buymeacoffee.svg',
                      tooltip: l10n.buyMeACoffeeTooltip,
                      onPressed: () => _openUrl(_buyMeACoffeeUrl),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          ListTile(
            leading: const Icon(LucideIcons.heart_handshake),
            title: Text(l10n.donateMenuLabel),
            trailing: const Icon(LucideIcons.chevron_right),
            onTap: () => context.push('/donate'),
          ),
          ListTile(
            leading: const Icon(LucideIcons.scroll),
            title: Text(l10n.changelogMenuLabel),
            trailing: const Icon(LucideIcons.chevron_right),
            onTap: () => context.push('/changelog'),
          ),
          ListTile(
            leading: const Icon(LucideIcons.scale),
            title: Text(l10n.legalMenuLabel),
            trailing: const Icon(LucideIcons.chevron_right),
            onTap: () => context.push('/legal'),
          ),
          ListTile(
            leading: const Icon(LucideIcons.git_pull_request),
            title: Text(l10n.contributingMenuLabel),
            trailing: const Icon(LucideIcons.external_link),
            onTap: () => _openUrl(_contributingUrl),
          ),
        ],
      ),
    );
  }
}
