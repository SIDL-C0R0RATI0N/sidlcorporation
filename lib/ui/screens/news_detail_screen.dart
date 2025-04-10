import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:sidlcorporation/data/models/news_item.dart';
import 'package:sidlcorporation/ui/screens/webview_screen.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsItem newsItem;

  const NewsDetailScreen({
    Key? key,
    required this.newsItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Actualité'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => WebViewScreen(
                  url: newsItem.link,
                  title: 'Article',
                ),
              ),
            );
          },
          child: const Icon(
            CupertinoIcons.globe,
            size: 22,
          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image de l'article
              if (newsItem.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    newsItem.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: CupertinoColors.systemGrey5,
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.photo,
                            size: 50,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 16),

              // Titre
              Text(
                newsItem.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Métadonnées (date et auteur)
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.calendar,
                    size: 16,
                    color: CupertinoColors.systemGrey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd MMMM yyyy', 'fr_FR').format(newsItem.pubDate),
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    CupertinoIcons.person,
                    size: 16,
                    color: CupertinoColors.systemGrey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      newsItem.creator,
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Contenu
              Html(
                data: newsItem.content,
                style: {
                  "body": Style(
                    fontSize: FontSize(16.0),
                    lineHeight: LineHeight(1.6),
                  ),
                  "h1": Style(
                    fontSize: FontSize(22.0),
                    fontWeight: FontWeight.bold,
                  ),
                  "h2": Style(
                    fontSize: FontSize(20.0),
                    fontWeight: FontWeight.bold,
                  ),
                  "p": Style(
                    margin: Margins.only(bottom: 16),
                  ),
                  "a": Style(
                    color: CupertinoTheme.of(context).primaryColor,
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}