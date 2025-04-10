import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:sidlcorporation/data/models/news_item.dart';
import 'package:sidlcorporation/ui/screens/webview_screen.dart';
import 'dart:ui';

class NewsDetailScreen extends StatelessWidget {
  final NewsItem newsItem;

  const NewsDetailScreen({
    Key? key,
    required this.newsItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CupertinoTheme.of(context).brightness == Brightness.dark;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: (isDarkMode
            ? CupertinoColors.black
            : CupertinoColors.systemBackground)
            .withOpacity(0.7),
        border: null,
        middle: const Text(
          'Actualité',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
                    DateFormat('dd/MM/yyyy').format(newsItem.pubDate),
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
              const Divider(),
              const SizedBox(height: 16),

              // Test pour vérifier si le contenu s'affiche
              Text(
                "Aperçu du contenu:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: CupertinoTheme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),

              // Affichage d'un extrait du contenu en texte brut
              Text(
                _cleanHtmlContent(newsItem.content).substring(0,
                    _cleanHtmlContent(newsItem.content).length > 200
                        ? 200
                        : _cleanHtmlContent(newsItem.content).length) + "...",
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 16),

              // Bouton pour voir l'article complet
              Center(
                child: CupertinoButton.filled(
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
                  child: const Text('Voir l\'article complet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour nettoyer le contenu HTML
  String _cleanHtmlContent(String htmlContent) {
    // Supprimer les balises HTML pour obtenir du texte brut
    return htmlContent
        .replaceAll(RegExp(r'<[^>]*>'), '') // Supprime les balises HTML
        .replaceAll('&nbsp;', ' ')         // Remplace les espaces insécables
        .replaceAll(RegExp(r'\s+'), ' ')   // Remplace les espaces multiples par un seul
        .trim();                           // Supprime les espaces au début et à la fin
  }
}