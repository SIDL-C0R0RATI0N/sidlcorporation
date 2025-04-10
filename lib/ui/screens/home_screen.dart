import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sidlcorporation/config/constants.dart';
import 'package:sidlcorporation/config/theme_provider.dart';
import 'package:sidlcorporation/data/models/company_info.dart';
import 'package:sidlcorporation/data/services/api_service.dart';
import 'package:sidlcorporation/ui/screens/news_screen.dart';
import 'package:sidlcorporation/ui/screens/settings_screen.dart';
import 'package:sidlcorporation/ui/screens/webview_screen.dart';
import 'package:sidlcorporation/ui/widgets/blur_card.dart';
import 'package:sidlcorporation/ui/widgets/company_info_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final ApiService _apiService = ApiService();
  late Future<CompanyInfo> _companyInfoFuture;

  @override
  void initState() {
    super.initState();
    _companyInfoFuture = _apiService.getCompanyInfo();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
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
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('SIDL CORPORATION'),
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
                    // En-tête avec effet blur
                    BlurCard(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              companyInfo.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              companyInfo.description,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CupertinoButton.filled(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                              child: const Text('Accéder au site'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

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