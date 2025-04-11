import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/news_model.dart';
import '../widgets/news_card.dart';
import 'package:intl/date_symbol_data_local.dart';

class NewsroomScreen extends StatefulWidget {
  const NewsroomScreen({Key? key}) : super(key: key);

  @override
  State<NewsroomScreen> createState() => _NewsroomScreenState();
}

class _NewsroomScreenState extends State<NewsroomScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<NewsItem>> _newsFuture;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    // Initialiser les données de localisation pour la formatation des dates
    initializeDateFormatting('fr_FR', null).then((_) {
      _newsFuture = _fetchNews();
    });
  }

  Future<List<NewsItem>> _fetchNews() async {
    try {
      return await _apiService.getNews();
    } catch (error) {
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
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshNews,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 90, bottom: 10),
        child: FutureBuilder<List<NewsItem>>(
          future: _newsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && !_isRefreshing) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erreur: ${snapshot.error}',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _newsFuture = _fetchNews();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final news = snapshot.data!;

              if (news.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Aucune actualité disponible',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: news.length,
                itemBuilder: (context, index) {
                  return NewsCard(news: news[index]);
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}