import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sidlcorporation/config/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Paramètres'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 16),

            // Section Apparence
            _buildSectionHeader(context, 'Apparence'),
            _buildToggleSetting(
              context,
              icon: CupertinoIcons.moon_stars_fill,
              title: 'Mode sombre',
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(),
            ),

            // Section Informations
            _buildSectionHeader(context, 'Informations'),
            _buildSettingsItem(
              context,
              icon: CupertinoIcons.info_circle_fill,
              title: 'À propos de l\'application',
              onTap: () => _showAboutDialog(context),
            ),
            _buildSettingsItem(
              context,
              icon: CupertinoIcons.doc_text_fill,
              title: 'Mentions légales',
              onTap: () => _openLegalPage(context),
            ),
            _buildSettingsItem(
              context,
              icon: CupertinoIcons.lock_fill,
              title: 'Politique de confidentialité',
              onTap: () => _openPrivacyPage(context),
            ),

            // Section Support
            _buildSectionHeader(context, 'Support'),
            _buildSettingsItem(
              context,
              icon: CupertinoIcons.chat_bubble_2_fill,
              title: 'Contacter le support',
              onTap: () => _contactSupport(),
            ),
            _buildSettingsItem(
              context,
              icon: CupertinoIcons.star_fill,
              title: 'Noter l\'application',
              onTap: () => _rateApp(),
            ),

            // Version
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 13,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: CupertinoTheme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        VoidCallback? onTap,
      }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CupertinoTheme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF38383A)
                  : CupertinoColors.separator,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: CupertinoTheme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: CupertinoTheme.of(context).primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemGrey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSetting(
      BuildContext context, {
        required IconData icon,
        required String title,
        required bool value,
        required ValueChanged<bool> onChanged,
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoTheme.of(context).brightness == Brightness.dark
                ? const Color(0xFF38383A)
                : CupertinoColors.separator,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: CupertinoTheme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: CupertinoTheme.of(context).primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeColor: CupertinoTheme.of(context).primaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('À propos'),
        content: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: CupertinoTheme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'SIDL',
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'SIDL CORPORATION',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.systemGrey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Application officielle de SIDL CORPORATION. Retrouvez toutes les actualités et informations sur notre entreprise.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              '© 2025 SIDL CORPORATION\nTous droits réservés.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openLegalPage(BuildContext context) {
    // URL des mentions légales
    final url = Uri.parse('https://www.sidl-corporation.fr/mentions-legales');
    _launchUrl(url);
  }

  void _openPrivacyPage(BuildContext context) {
    // URL de la politique de confidentialité
    final url = Uri.parse('https://www.sidl-corporation.fr/confidentialite');
    _launchUrl(url);
  }

  void _contactSupport() {
    // Email du support
    final url = Uri.parse('mailto:contact@sidl-corporation.fr?subject=Support%20Application%20iOS');
    _launchUrl(url);
  }

  void _rateApp() {
    // URL pour noter l'application (remplacer [APP_ID] par l'identifiant réel)
    final url = Uri.parse('https://apps.apple.com/app/id[APP_ID]?action=write-review');
    _launchUrl(url);
  }

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}