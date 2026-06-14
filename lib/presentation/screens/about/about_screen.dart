import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/url_launcher_helper.dart';
import '../../widgets/app_bar_widget.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VilasAppBar(title: AppStrings.navAbout),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(child: VilasLogo()),
          const SizedBox(height: 24),
          Text(
            AppStrings.aboutTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.aboutText,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(height: 1.45),
          ),
          const SizedBox(height: 24),
          _ContactLine(
            icon: Icons.place_outlined,
            value: AppStrings.aboutAddress,
            onTap: () => UrlLauncherHelper.open(
              'https://maps.google.com/?q=Rua%20Praia%20do%20Quebra%20Coco%2033%20Vilas%20do%20Atlantico',
            ),
          ),
          _ContactLine(
            icon: Icons.phone_outlined,
            value: AppStrings.aboutPhones,
            onTap: () => UrlLauncherHelper.call('7133792439'),
          ),
          _ContactLine(
            icon: Icons.mail_outline,
            value: AppStrings.aboutEmail,
            onTap: () => UrlLauncherHelper.email(AppStrings.aboutEmail),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: () => UrlLauncherHelper.open(
                  'https://www.facebook.com/VilasMagazine.Online',
                ),
                icon: const Icon(Icons.facebook_outlined),
                label: const Text(AppStrings.facebook),
              ),
              OutlinedButton.icon(
                onPressed: () => UrlLauncherHelper.open(
                  'https://www.instagram.com/vilasmagazine',
                ),
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text(AppStrings.instagram),
              ),
              ElevatedButton.icon(
                onPressed: () => UrlLauncherHelper.whatsapp('7133792439'),
                icon: const Icon(Icons.chat_outlined),
                label: const Text(AppStrings.whatsapp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactLine extends StatelessWidget {
  const _ContactLine({
    required this.icon,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
