import 'package:flutter/cupertino.dart';
import 'package:sidlcorporation/config/constants.dart';
import 'package:sidlcorporation/data/models/company_info.dart';
import 'package:sidlcorporation/data/services/api_service.dart';
import 'package:sidlcorporation/ui/common/app_scaffold.dart';
import 'package:sidlcorporation/ui/screens/news_screen.dart';
import 'package:sidlcorporation/ui/screens/settings_screen.dart';
import 'package:sidlcorporation/ui/screens/webview_screen.dart';
import 'package:sidlcorporation/ui/widgets/app_card.dart';
import 'package:sidlcorporation/ui/widgets/company_info_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final ApiService _apiService = ApiService(useMock: false);
  late Future<CompanyInfo> _companyInfoFuture;

  @override
  void initState() {
    super.initState();
    _companyInfoFuture = _apiService.getCompanyInfo();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'SIDL CORPORATION',
      currentIndex: _currentIndex,
      onTabSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      trailing: _currentIndex == 0 ? CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            _companyInfoFuture = _apiService.getCompanyInfo();
          });
        },
        child: const Icon(
          CupertinoIcons.refresh,
          size: 22,
        ),
      ) : null,
      body: _buildScreen(),
    );
  }

  Widget _buildScreen() {
    return IndexedStack(
      index: _currentIndex,
      children: [
        _buildHomeTab(),
        const NewsScreen(),
        const SettingsScreen(),
      ],
    );
  }

  Widget _buildHomeTab() {
    return SafeArea(
      bottom: false, // Pas de marge en bas pour la tab bar personnalisée
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 90, bottom: 90), // Espace pour les barres translucides
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder<CompanyInfo>(
            future: _companyInfoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CupertinoActivityIndicator(radius: 20),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      'Erreur: ${snapshot.error}',
                      style: const TextStyle(color: CupertinoColors.systemRed),
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                final companyInfo = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // En-tête de l'entreprise
                    AppCard(
                      useBlur: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Étiquette
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

                          // Nom et description
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

                          // Bouton d'accès au site
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
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: CupertinoTheme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    CupertinoIcons.globe,
                                    size: 16,
                                    color: CupertinoColors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Accéder au site',
                                    style: TextStyle(
                                      color: CupertinoColors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Informations détaillées de l'entreprise
                    CompanyInfoWidget(companyInfo: companyInfo),
                  ],
                );
              } else {
                return const Center(
                  child: Text('Aucune information disponible'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}