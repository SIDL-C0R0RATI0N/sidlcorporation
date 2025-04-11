import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../widgets/web_view_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';

class NewsCard extends StatelessWidget {
  final NewsItem news;
  final bool isFirstCard;

  const NewsCard({
    Key? key,
    required this.news,
    this.isFirstCard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: isFirstCard ? 0 : 12,
          bottom: 12
      ),
      child: GestureDetector(
        onTap: () {
          if (news.link != null && news.link!.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewContainer(
                  url: news.link!,
                  title: news.title,
                ),
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isLightMode ? Colors.white : const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isLightMode
                    ? Colors.black.withOpacity(0.05)
                    : Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              _buildImageSection(context),

              // Content section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Text(
                      news.date,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Title
                    Text(
                      news.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        color: isLightMode ? Colors.black : Colors.white,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      news.description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: isLightMode
                            ? Colors.black.withOpacity(0.7)
                            : Colors.white.withOpacity(0.7),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Read more button
                    if (news.link != null && news.link!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Lire plus',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
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

  Widget _buildImageSection(BuildContext context) {
    // Si l'article a une URL d'image valide
    if (news.hasImage) {
      return Container(
        height: 200,
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: news.imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildImagePlaceholder(context),
          errorWidget: (context, url, error) => _buildImageErrorWidget(context),
        ),
      );
    }
    // Sinon, utiliser l'image par défaut
    else {
      return Container(
        height: 160,
        width: double.infinity,
        child: _buildImagePlaceholder(context),
      );
    }
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return Container(
      color: isLightMode ? Colors.grey.shade200 : Colors.grey.shade800,
      child: Center(
        child: Icon(
          Icons.photo,
          size: 48,
          color: isLightMode ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildImageErrorWidget(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return Container(
      color: isLightMode ? Colors.grey.shade200 : Colors.grey.shade800,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_rounded,
              size: 40,
              color: isLightMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              'Image non disponible',
              style: TextStyle(
                color: isLightMode ? Colors.grey.shade600 : Colors.grey.shade400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}