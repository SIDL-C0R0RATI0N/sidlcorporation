import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
        border: null,
        transitionBetweenRoutes: false,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image de l'article en pleine largeur avec un effet de dégradé
              if (newsItem.imageUrl.isNotEmpty)
                Stack(
                  children: [
                    Image.network(
                      newsItem.imageUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 250,
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
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            CupertinoColors.black.withOpacity(0),
                            CupertinoColors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: CupertinoTheme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ACTUALITÉ',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              // Contenu de l'article
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Text(
                      newsItem.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 12),

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
                          DateFormat('dd MMMM yyyy').format(newsItem.pubDate),
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

                    // Contenu
                    _buildContentPreview(newsItem.content),

                    const SizedBox(height: 24),

                    // Bouton pour lire sur le site
                    Center(
                      child: CupertinoButton(
                        color: CupertinoTheme.of(context).primaryColor,
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
                        // Assurez-vous que le texte est toujours blanc, quelle que soit le thème
                        child: const Text(
                          'Lire l\'article complet',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentPreview(String content) {
    // Nettoyage du HTML pour afficher du texte brut
    String plainText = content
        .replaceAll(RegExp(r'<[^>]*>'), '') // Supprime les balises HTML
        .replaceAll('&nbsp;', ' ')         // Remplace les espaces insécables
        .replaceAll(RegExp(r'\s+'), ' ')   // Remplace les espaces multiples
        .trim();                         // Supprime les espaces au début et à la fin

    // Limiter à un aperçu
    if (plainText.length > 500) {
      plainText = plainText.substring(0, 500) + '...';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          plainText,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),

        // Ajouter de l'espace après le texte pour éviter la partie vide
        const SizedBox(height: 20),
      ],
    );
  }
}