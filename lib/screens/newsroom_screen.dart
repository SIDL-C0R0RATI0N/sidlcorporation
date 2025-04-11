import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/news_model.dart';
import '../widgets/news_card.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';

class NewsroomScreen extends StatefulWidget {
  const NewsroomScreen({Key? key}) : super(key: key);

  @override
  State<NewsroomScreen> createState() => _NewsroomScreenState();
}

class _NewsroomScreenState extends State<NewsroomScreen> with AutomaticKeepAliveClientMixin {
  final ApiService _apiService = ApiService();
  late Future<List<NewsItem>> _newsFuture;
  bool _isRefreshing = false;
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true; // Garder l'état lors du changement d'onglet

  @override
  void initState() {
    super.initState();
    // Initialiser les données de localisation pour la formatation des dates
    initializeDateFormatting('fr_FR', null).then((_) {
      _newsFuture = _fetchNews();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<NewsItem>> _fetchNews() async {
    try {
      return await _apiService.getNews();
    } catch (error) {
      print('Erreur dans _fetchNews: $error');
      throw Exception('Erreur lors du chargement des actualités: $error');
    }
  }

  Future<void> _refreshNews() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      final newsData = await _apiService.getNews();
      setState(() {
        _newsFuture = Future.value(newsData);
        _isRefreshing = false;
      });
    } catch (error) {
      setState(() {
        _isRefreshing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'actualisation: $error'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
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

    return RefreshIndicator(
      onRefresh: _refreshNews,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 90),
        child: FutureBuilder<List<NewsItem>>(
          future: _newsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && !_isRefreshing) {
              return _buildLoadingState();
            } else if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            } else if (snapshot.hasData) {
              final news = snapshot.data!;

              if (news.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.only(bottom: 90),
                itemCount: news.length,
                itemBuilder: (context, index) {
                  return NewsCard(
                    news: news[index],
                    isFirstCard: index == 0,
                  );
                },
              );
            } else {
              return _buildLoadingState();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: Lottie.asset(
              'assets/animations/news_loading.json',
              frameRate: FrameRate.max,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Chargement des actualités...',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black54
                  : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              child: Lottie.asset(
                'assets/animations/error.json',
                repeat: false,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Impossible de charger les actualités',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isLightMode ? Colors.black87 : Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Vérifiez votre connexion internet et réessayez.',
              style: TextStyle(
                fontSize: 14,
                color: isLightMode ? Colors.black54 : Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _newsFuture = _fetchNews();
                });
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 100,
            color: isLightMode ? Colors.grey.shade300 : Colors.grey.shade700,
          ),
          const SizedBox(height: 24),
          Text(
            'Aucune actualité disponible',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isLightMode ? Colors.black87 : Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Revenez plus tard pour voir les dernières actualités',
            style: TextStyle(
              fontSize: 14,
              color: isLightMode ? Colors.black54 : Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}