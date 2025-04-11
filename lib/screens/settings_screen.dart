import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/web_view_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../utils/theme_provider.dart' as utils;
import '../utils/theme_provider.dart';
import '../config/app_config.dart';
import 'dart:async';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with AutomaticKeepAliveClientMixin {
  // Utilisation de valeurs statiques au lieu de PackageInfo
  String _appVersion = AppConfig.appVersion;
  String _buildNumber = AppConfig.buildNumber;
  bool _notificationsEnabled = true;
  utils.ThemeMode _selectedThemeMode = utils.ThemeMode.system;
  bool _reducedMotion = false;
  bool _reducedTransparency = false;
  String _deviceInfo = "";
  bool _isLoadingDeviceInfo = true;
  bool _biometricEnabled = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadDeviceInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initThemeMode();
  }

  void _initThemeMode() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    setState(() {
      _selectedThemeMode = themeProvider.themeMode;
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _reducedMotion = prefs.getBool('reducedMotion') ?? false;
      _reducedTransparency = prefs.getBool('reducedTransparency') ?? false;
      _biometricEnabled = prefs.getBool('biometricEnabled') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setBool('reducedMotion', _reducedMotion);
    await prefs.setBool('reducedTransparency', _reducedTransparency);
    await prefs.setBool('biometricEnabled', _biometricEnabled);
  }

  Future<void> _loadDeviceInfo() async {
    try {
      String deviceInfo = "";

      if (Platform.isIOS) {
        deviceInfo = "iOS ${Platform.operatingSystemVersion}";
      } else if (Platform.isAndroid) {
        deviceInfo = "Android ${Platform.operatingSystemVersion}";
      } else {
        deviceInfo = Platform.operatingSystem;
      }

      setState(() {
        _deviceInfo = deviceInfo;
        _isLoadingDeviceInfo = false;
      });
    } catch (e) {
      setState(() {
        _deviceInfo = "Information non disponible";
        _isLoadingDeviceInfo = false;
      });
    }
  }

  void _changeThemeMode(utils.ThemeMode themeMode) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.setThemeMode(themeMode);
    setState(() {
      _selectedThemeMode = themeMode;
    });
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    _saveSettings();
  }

  void _toggleReducedMotion(bool value) {
    setState(() {
      _reducedMotion = value;
    });
    _saveSettings();
  }

  void _toggleReducedTransparency(bool value) {
    setState(() {
      _reducedTransparency = value;
    });
    _saveSettings();
  }

  void _toggleBiometric(bool value) {
    setState(() {
      _biometricEnabled = value;
    });
    _saveSettings();

    if (value) {
      // Normalement, on afficherait une boîte de dialogue pour configurer la biométrie ici
      _showBiometricSetupDialog();
    }
  }

  void _showBiometricSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configuration biométrique'),
        content: const Text(
          'Pour utiliser la biométrie, vous devez avoir configuré Face ID, Touch ID ou le scanner d\'empreintes digitales dans les paramètres de votre appareil.',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAppData() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Effacer les données'),
          content: const Text(
            'Êtes-vous sûr de vouloir effacer toutes les données de l\'application ? Cette action est irréversible.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Simuler l'effacement des données
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // Recharger les valeurs par défaut
                _loadSettings();

                // Afficher une confirmation
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Données effacées avec succès'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text(
                'Effacer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _contactSupport() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@sidl-corporation.fr',
      query: 'subject=Support%20Application%20Mobile&body=Version%20de%20l%27application%3A%20$_appVersion%20($_buildNumber)%0A%0AAppareil%3A%20$_deviceInfo%0A%0ADescription%20du%20problème%3A%20',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        // Fallback si le client mail ne peut pas être lancé
        _showSupportDialog();
      }
    } catch (e) {
      _showSupportDialog();
    }
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contacter le support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Envoyez un email à:'),
            const SizedBox(height: 8),
            SelectableText(
              'support@sidl-corporation.fr',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Veuillez inclure:'),
            const SizedBox(height: 8),
            Text('• Version: $_appVersion ($_buildNumber)'),
            Text('• Appareil: $_deviceInfo'),
            const Text('• Description détaillée du problème'),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Future<void> _rateApp() async {
    final Uri storeUri;

    if (Platform.isIOS) {
      // URL App Store
      storeUri = Uri.parse('https://apps.apple.com/app/idXXXXXXXXXX');
    } else if (Platform.isAndroid) {
      // URL Play Store
      storeUri = Uri.parse('https://play.google.com/store/apps/details?id=fr.sidl_corporation.app');
    } else {
      // URL site web
      storeUri = Uri.parse('https://sidl-corporation.fr/app');
    }

    try {
      if (await canLaunchUrl(storeUri)) {
        await launchUrl(storeUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Impossible d\'ouvrir $storeUri';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Impossible d\'ouvrir la page d\'évaluation: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Nécessaire pour AutomaticKeepAliveClientMixin

    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.only(top: 90, bottom: 10),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Section Apparence
          _buildSectionHeader(context, 'Apparence'),
          _buildSettingsCard(
            context,
            children: [
              _buildThemeModeTile(
                context,
                title: 'Thème de l\'application',
                icon: Icons.palette_rounded,
              ),
              const Divider(),
              _buildSwitchTile(
                context,
                title: 'Réduire les animations',
                subtitle: 'Diminue les effets de mouvement dans l\'interface',
                value: _reducedMotion,
                onChanged: _toggleReducedMotion,
                icon: Icons.animation_rounded,
              ),
              const Divider(),
              _buildSwitchTile(
                context,
                title: 'Réduire la transparence',
                subtitle: 'Diminue les effets de flou et de transparence',
                value: _reducedTransparency,
                onChanged: _toggleReducedTransparency,
                icon: Icons.blur_on_rounded,
              ),
            ],
          ),

          // Section Notifications et confidentialité
          _buildSectionHeader(context, 'Notifications et confidentialité'),
          _buildSettingsCard(
            context,
            children: [
              _buildSwitchTile(
                context,
                title: 'Notifications push',
                subtitle: 'Recevoir des notifications de l\'application',
                value: _notificationsEnabled,
                onChanged: _toggleNotifications,
                icon: Icons.notifications_rounded,
              ),
              const Divider(),
              _buildSwitchTile(
                context,
                title: 'Authentification biométrique',
                subtitle: 'Utiliser Face ID ou Touch ID pour déverrouiller l\'application',
                value: _biometricEnabled,
                onChanged: _toggleBiometric,
                icon: Icons.fingerprint_rounded,
              ),
            ],
          ),

          // Section À propos
          _buildSectionHeader(context, 'À propos'),
          _buildSettingsCard(
            context,
            children: [
              _buildInfoTile(
                context,
                title: 'Version de l\'application',
                subtitle: '$_appVersion ($_buildNumber)',
                icon: Icons.info_rounded,
              ),
              const Divider(),
              _buildInfoTile(
                context,
                title: 'Appareil',
                subtitle: _isLoadingDeviceInfo ? 'Chargement...' : _deviceInfo,
                icon: Icons.devices_rounded,
              ),
              const Divider(),
              _buildActionTile(
                context,
                title: 'Conditions d\'utilisation',
                icon: Icons.description_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WebViewContainer(
                        url: 'https://sidl-corporation.fr/terms',
                        title: 'Conditions d\'utilisation',
                      ),
                    ),
                  );
                },
              ),
              const Divider(),
              _buildActionTile(
                context,
                title: 'Politique de confidentialité',
                icon: Icons.privacy_tip_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WebViewContainer(
                        url: 'https://sidl-corporation.fr/privacy',
                        title: 'Politique de confidentialité',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          // Section Support
          _buildSectionHeader(context, 'Support'),
          _buildSettingsCard(
            context,
            children: [
              _buildActionTile(
                context,
                title: 'Contacter le support',
                icon: Icons.support_agent_rounded,
                onTap: _contactSupport,
              ),
              const Divider(),
              _buildActionTile(
                context,
                title: 'Visiter notre site web',
                icon: Icons.language_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WebViewContainer(
                        url: 'https://sidl-corporation.fr',
                        title: 'SIDL Corporation',
                      ),
                    ),
                  );
                },
              ),
              const Divider(),
              _buildActionTile(
                context,
                title: 'Suivez-nous sur les réseaux sociaux',
                icon: Icons.share_rounded,
                onTap: () {
                  _showSocialMediaDialog();
                },
              ),
            ],
          ),

          // Section Autres actions
          _buildSectionHeader(context, 'Autres actions'),
          _buildSettingsCard(
            context,
            children: [
              _buildActionTile(
                context,
                title: 'Effacer le cache',
                icon: Icons.cleaning_services_rounded,
                onTap: () async {
                  // Simuler une action d'effacement du cache
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cache effacé'),
                      content: const Text('Le cache de l\'application a été effacé avec succès.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                },
              ),
              const Divider(),
              _buildActionTile(
                context,
                title: 'Effacer les données',
                icon: Icons.delete_rounded,
                onTap: _clearAppData,
              ),
              const Divider(),
              _buildActionTile(
                context,
                title: 'Évaluer l\'application',
                icon: Icons.star_rounded,
                onTap: _rateApp,
              ),
            ],
          ),

          // Section d'informations légales
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  '© ${DateTime.now().year} SIDL Corporation',
                  style: TextStyle(
                    color: isLightMode ? Colors.black54 : Colors.white54,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tous droits réservés.',
                  style: TextStyle(
                    color: isLightMode ? Colors.black54 : Colors.white54,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSocialMediaDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suivez-nous'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSocialButton(
              context,
              text: 'Facebook',
              icon: Icons.facebook_rounded,
              color: const Color(0xFF1877F2),
              onTap: () async {
                Navigator.pop(context);
                final Uri url = Uri.parse('https://facebook.com/sidlcorporation');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
            const SizedBox(height: 12),
            _buildSocialButton(
              context,
              text: 'Twitter',
              icon: Icons.send_rounded,
              color: const Color(0xFF1DA1F2),
              onTap: () async {
                Navigator.pop(context);
                final Uri url = Uri.parse('https://twitter.com/sidlcorporation');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
            const SizedBox(height: 12),
            _buildSocialButton(
              context,
              text: 'Instagram',
              icon: Icons.camera_alt_rounded,
              color: const Color(0xFFE1306C),
              onTap: () async {
                Navigator.pop(context);
                final Uri url = Uri.parse('https://instagram.com/sidlcorporation');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
            const SizedBox(height: 12),
            _buildSocialButton(
              context,
              text: 'LinkedIn',
              icon: Icons.work_rounded,
              color: const Color(0xFF0077B5),
              onTap: () async {
                Navigator.pop(context);
                final Uri url = Uri.parse('https://linkedin.com/company/sidlcorporation');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
      BuildContext context, {
        required String text,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 16),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
      BuildContext context, {
        required List<Widget> children,
      }) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isLightMode ? Colors.white : const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isLightMode
                ? Colors.black.withOpacity(0.05)
                : Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
      BuildContext context, {
        required String title,
        required String subtitle,
        required bool value,
        required Function(bool) onChanged,
        required IconData icon,
      }) {
    final primaryColor = Theme.of(context).primaryColor;

    return SwitchListTile.adaptive(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: primaryColor,
      activeTrackColor: primaryColor.withOpacity(0.3),
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.grey.withOpacity(0.3),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: primaryColor,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildInfoTile(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
      }) {
    final primaryColor = Theme.of(context).primaryColor;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: primaryColor,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildActionTile(
      BuildContext context, {
        required String title,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    final primaryColor = Theme.of(context).primaryColor;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: primaryColor,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
      ),
      onTap: onTap,
    );
  }

  Widget _buildThemeModeTile(
      BuildContext context, {
        required String title,
        required IconData icon,
      }) {
    final primaryColor = Theme.of(context).primaryColor;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: primaryColor,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: _getThemeModeSubtitle(),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
      ),
      onTap: () => _showThemeModeDialog(context),
    );
  }

  Widget _getThemeModeSubtitle() {
    String themeModeText;
    IconData iconData;

    switch (_selectedThemeMode) {
      case utils.ThemeMode.system:
        themeModeText = 'Utiliser le thème du système';
        iconData = Icons.brightness_auto_rounded;
        break;
      case utils.ThemeMode.light:
        themeModeText = 'Mode clair';
        iconData = Icons.brightness_5_rounded;
        break;
      case utils.ThemeMode.dark:
        themeModeText = 'Mode sombre';
        iconData = Icons.brightness_3_rounded;
        break;
    }

    return Row(
      children: [
        Icon(
          iconData,
          size: 14,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 6),
        Text(
          themeModeText,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  void _showThemeModeDialog(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thème de l\'application'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeModeOption(
                context,
                title: 'Système',
                subtitle: 'Utiliser le thème du système',
                icon: Icons.brightness_auto_rounded,
                themeMode: utils.ThemeMode.system,
              ),
              const SizedBox(height: 8),
              _buildThemeModeOption(
                context,
                title: 'Clair',
                subtitle: 'Toujours utiliser le thème clair',
                icon: Icons.brightness_5_rounded,
                themeMode: utils.ThemeMode.light,
              ),
              const SizedBox(height: 8),
              _buildThemeModeOption(
                context,
                title: 'Sombre',
                subtitle: 'Toujours utiliser le thème sombre',
                icon: Icons.brightness_3_rounded,
                themeMode: utils.ThemeMode.dark,
              ),
            ],
          ),
          backgroundColor: isLightMode ? Colors.white : const Color(0xFF1C1C1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }

  Widget _buildThemeModeOption(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required utils.ThemeMode themeMode,
      }) {
    final isSelected = _selectedThemeMode == themeMode;
    final primaryColor = Theme.of(context).primaryColor;

    return Material(
        color: Colors.transparent,
        child: InkWell(
        onTap: () {
      _changeThemeMode(themeMode);
      Navigator.pop(context);
    },
    borderRadius: BorderRadius.circular(16),
    child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
    color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
    color: isSelected ? primaryColor : Colors.transparent,
    width: 1,
    ),
    ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check_circle_rounded,
              color: primaryColor,
              size: 22,
            ),
        ],
      ),
    ),
        ),
    );
  }
}