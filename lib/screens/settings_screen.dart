import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/web_view_container.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../utils/theme_provider.dart' as utils;
import '../utils/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '';
  String _buildNumber = '';
  bool _notificationsEnabled = true;
  utils.ThemeMode _selectedThemeMode = utils.ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _getAppInfo();
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
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', _notificationsEnabled);
  }

  Future<void> _getAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
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

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

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
                icon: Icons.palette,
              ),
            ],
          ),

          // Section Notifications
          _buildSectionHeader(context, 'Notifications'),
          _buildSettingsCard(
            context,
            children: [
              _buildSwitchTile(
                context,
                title: 'Notifications push',
                subtitle: 'Recevoir des notifications de l\'application',
                value: _notificationsEnabled,
                onChanged: _toggleNotifications,
                icon: Icons.notifications,
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
                icon: Icons.info,
              ),
              const Divider(),
              _buildActionTile(
                context,
                title: 'Conditions d\'utilisation',
                icon: Icons.description,
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
                icon: Icons.privacy_tip,
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
              const Divider(),
              _buildActionTile(
                context,
                title: 'Contacter le support',
                icon: Icons.support_agent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WebViewContainer(
                        url: 'https://sidl-corporation.fr/contact',
                        title: 'Contacter le support',
                      ),
                    ),
                  );
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
                icon: Icons.cleaning_services,
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
                    ),
                  );
                },
              ),
              const Divider(),
              _buildActionTile(
                context,
                title: 'Évaluer l\'application',
                icon: Icons.star,
                onTap: () {
                  // Ouvrir la page de l'app store pour évaluation
                  // Dans une implémentation réelle, vous utiliseriez un package comme url_launcher
                  // pour ouvrir l'URL de l'App Store ou du Play Store
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ouverture de la page d\'évaluation...'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isLightMode ? Colors.white : const Color(0xFF1C1C1E),
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
      activeColor: Theme.of(context).primaryColor,
      secondary: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildInfoTile(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
      }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
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
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildThemeModeTile(
      BuildContext context, {
        required String title,
        required IconData icon,
      }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: _getThemeModeSubtitle(),
      onTap: () => _showThemeModeDialog(context),
    );
  }

  Widget _getThemeModeSubtitle() {
    String themeModeText;
    switch (_selectedThemeMode) {
      case utils.ThemeMode.system:
        themeModeText = 'Utiliser le thème du système';
        break;
      case utils.ThemeMode.light:
        themeModeText = 'Mode clair';
        break;
      case utils.ThemeMode.dark:
        themeModeText = 'Mode sombre';
        break;
    }

    return Text(
      themeModeText,
      style: TextStyle(
        fontSize: 14,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }

  void _showThemeModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thème de l\'application'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeModeOption(
                context,
                title: 'Système',
                subtitle: 'Utiliser le thème du système',
                icon: Icons.brightness_auto,
                themeMode: utils.ThemeMode.system,
              ),
              const Divider(),
              _buildThemeModeOption(
                context,
                title: 'Clair',
                subtitle: 'Toujours utiliser le thème clair',
                icon: Icons.brightness_high,
                themeMode: utils.ThemeMode.light,
              ),
              const Divider(),
              _buildThemeModeOption(
                context,
                title: 'Sombre',
                subtitle: 'Toujours utiliser le thème sombre',
                icon: Icons.brightness_2,
                themeMode: utils.ThemeMode.dark,
              ),
            ],
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

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Icon(
        Icons.check_circle,
        color: Theme.of(context).primaryColor,
      )
          : null,
      onTap: () {
        _changeThemeMode(themeMode);
        Navigator.pop(context);
      },
    );
  }
}