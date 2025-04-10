import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sidlcorporation/config/constants.dart';
import 'package:sidlcorporation/config/theme_provider.dart';
import 'package:sidlcorporation/data/models/company_info.dart';
import 'package:sidlcorporation/data/services/api_service.dart';
import 'package:sidlcorporation/ui/screens/news_screen.dart';
import 'package:sidlcorporation/ui/screens/settings_screen.dart';
import 'package:sidlcorporation/ui/screens/webview_screen.dart';
import 'package:sidlcorporation/ui/widgets/company_info_widget.dart';
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService(useMock: true);
  late Future<CompanyInfo> _companyInfoFuture;

  @override
  void initState() {
    super.initState();
    _companyInfoFuture = _apiService.getCompanyInfo();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CupertinoTheme.of(context).brightness == Brightness.dark;
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        // Style App Store avec effet translucide
        backgroundColor: (isDarkMode
            ? CupertinoColors.black
            : CupertinoColors.systemBackground)
            .withOpacity(0.7),
        border: const Border(
          top: BorderSide(
            color: CupertinoColors.separator,
            width: 0.5,
          ),
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.news),
            label: 'Newsroom',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                return _buildHomeTab();
              case 1:
                return const NewsScreen();
              case 2:
                return const SettingsScreen();
              default:
                return _buildHomeTab();
            }
          },
        );
      },
    );
  }

  Widget _buildHomeTab() {
    final isDarkMode = CupertinoTheme.of(context).brightness == Brightness.dark;
    return CupertinoPageScaffold(
      // NavigationBar avec effet blur inspiré de l'App Store
      navigationBar: CupertinoNavigationBar(
        backgroundColor: (isDarkMode
            ? CupertinoColors.black
            : CupertinoColors.systemBackground)
            .withOpacity(0.7),
        border: null, // Retirer la bordure
        middle: const Text(
          'SIDL CORPORATION',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<CompanyInfo>(
          future: _companyInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erreur: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              final companyInfo = snapshot.data!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // En-tête de l'entreprise style App Store
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey5.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: CupertinoTheme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'BIENVENUE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            companyInfo.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            companyInfo.description,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const WebViewScreen(
                                    url: AppConstants.websiteUrl,
                                    title: 'SIDL CORPORATION',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: CupertinoTheme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Accéder au site',
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Informations détaillées de l'entreprise
                    CompanyInfoWidget(companyInfo: companyInfo),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text('Aucune information disponible'),
              );
            }
          },
        ),
      ),
    );
  }
}