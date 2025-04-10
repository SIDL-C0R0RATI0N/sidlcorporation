import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sidlcorporation/data/models/news_item.dart';
import 'package:sidlcorporation/data/services/rss_service.dart';
import 'package:sidlcorporation/ui/screens/news_detail_screen.dart';
import 'package:sidlcorporation/ui/widgets/news_card.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final RssService _rssService = RssService();
  late Future<List<NewsItem>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _rssService.getNews();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false, // Pas de marge en bas pour la tab bar personnalisée
      child: Padding(
        padding: const EdgeInsets.only(top: 90), // Espace pour la barre de navigation
        child: FutureBuilder<List<NewsItem>>(
          future: _newsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
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
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final news = snapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 90.0, // Espace pour la tabbar
                ),
                itemCount: news.length,
                itemBuilder: (context, index) {
                  final newsItem = news[index];
                  return NewsCard(
                    imageUrl: newsItem.imageUrl,
                    title: newsItem.title,
                    date: DateFormat('dd/MM/yyyy').format(newsItem.pubDate),
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => NewsDetailScreen(newsItem: newsItem),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.news,
                      size: 64,
                      color: CupertinoColors.systemGrey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Aucune actualité disponible',
                      style: TextStyle(
                        fontSize: 18,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CupertinoButton(
                      onPressed: () {
                        setState(() {
                          _newsFuture = _rssService.getNews();
                        });
                      },
                      child: const Text('Actualiser'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}