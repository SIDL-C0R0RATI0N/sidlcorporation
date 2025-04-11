import 'package:flutter/material.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/web_view_container.dart';
import 'newsroom_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const _HomeScreenContent(),
    const NewsroomScreen(),
    const SettingsScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TranslucentAppBar(
        title: _getAppBarTitle(),
        showBackButton: false,
        actions: _getAppBarActions(),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: TranslucentBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'SIDL CORPORATION';
      case 1:
        return 'Newsroom';
      case 2:
        return 'Paramètres';
      default:
        return 'SIDL CORPORATION';
    }
  }

  List<Widget>? _getAppBarActions() {
    switch (_currentIndex) {
      case 0:
        return [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Action de recherche
            },
          ),
        ];
      case 1:
        return [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Action de rafraîchissement des news
            },
          ),
        ];
      default:
        return null;
    }
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 100, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bannière d'accueil
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Icon(
                      Icons.business,
                      size: 140,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Bienvenue chez',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'SIDL CORPORATION',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WebViewContainer(
                                  url: 'https://sidl-corporation.fr',
                                  title: 'Site Web Officiel',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Découvrir'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Section Services
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nos Services',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildServiceCard(
                        context,
                        'Web',
                        Icons.web,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WebViewContainer(
                                url: 'https://sidl-corporation.fr/services/web',
                                title: 'Services Web',
                              ),
                            ),
                          );
                        },
                      ),
                      _buildServiceCard(
                        context,
                        'Mobile',
                        Icons.smartphone,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WebViewContainer(
                                url: 'https://sidl-corporation.fr/services/mobile',
                                title: 'Services Mobile',
                              ),
                            ),
                          );
                        },
                      ),
                      _buildServiceCard(
                        context,
                        'Design',
                        Icons.palette,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WebViewContainer(
                                url: 'https://sidl-corporation.fr/services/design',
                                title: 'Services Design',
                              ),
                            ),
                          );
                        },
                      ),
                      _buildServiceCard(
                        context,
                        'Conseil',
                        Icons.lightbulb,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WebViewContainer(
                                url: 'https://sidl-corporation.fr/services/conseil',
                                title: 'Services Conseil',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Section À propos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Card(
                elevation: 0,
                color: isLightMode ? Colors.white : const Color(0xFF1C1C1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'À propos de nous',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'SIDL Corporation est une entreprise spécialisée dans le développement de solutions numériques innovantes pour les entreprises et les particuliers.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WebViewContainer(
                                url: 'https://sidl-corporation.fr/about',
                                title: 'À propos',
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('En savoir plus'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return Card(
      elevation: 0,
      color: isLightMode ? Colors.white : const Color(0xFF1C1C1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}