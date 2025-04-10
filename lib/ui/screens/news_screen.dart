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
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Newsroom'),
      ),
      child: SafeArea(
        child: FutureBuilder<List<NewsItem>>(
          future: _newsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erreur: ${snapshot.error}'),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final news = snapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
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
              return const Center(
                child: Text('Aucune actualité disponible'),
              );
            }
          },
        ),
      ),
    );
  }
}