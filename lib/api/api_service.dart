import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../models/news_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.sidl-corporation.fr/v5/app/ios';

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Headers génériques
  Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Méthode pour mettre à jour les headers (par exemple pour ajouter un token)
  void updateHeaders(Map<String, String> newHeaders) {
    _headers.addAll(newHeaders);
  }

  // GET générique
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
    );

    return _processResponse(response);
  }

  // POST générique
  Future<dynamic> post(String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
      body: json.encode(data),
    );

    return _processResponse(response);
  }

  // PUT générique
  Future<dynamic> put(String endpoint, dynamic data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
      body: json.encode(data),
    );

    return _processResponse(response);
  }

  // DELETE générique
  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
    );

    return _processResponse(response);
  }

  // Traitement de la réponse
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      }
      return {};
    } else {
      throw Exception('Erreur: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  // Récupérer les actualités depuis le flux RSS WordPress
  Future<List<NewsItem>> getNews() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.sidl-corporation.fr/feed'),
        headers: {'Accept': 'application/rss+xml'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _parseRssFeed(response.body);
      } else {
        throw Exception('Erreur: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des actualités: $e');
    }
  }

  // Analyser le flux RSS
  List<NewsItem> _parseRssFeed(String xmlString) {
    final List<NewsItem> newsList = [];

    try {
      final document = XmlDocument.parse(xmlString);
      final items = document.findAllElements('item');

      int id = 0;
      for (var item in items) {
        id++;

        // Éléments de base
        final title = _getElementText(item, 'title');
        final link = _getElementText(item, 'link');
        final pubDate = _getElementText(item, 'pubDate');
        String description = _getElementText(item, 'description');

        // Traitement de la date
        final date = _formatRssDate(pubDate);

        // Extraire l'image
        String imageUrl = '';

        // Essayer d'extraire l'image de l'élément media:content
        var mediaContent = item.findElements('media:content').firstOrNull;
        if (mediaContent != null) {
          imageUrl = mediaContent.getAttribute('url') ?? '';
        }

        // Si aucune image n'est trouvée, essayer d'extraire de la description HTML
        if (imageUrl.isEmpty) {
          imageUrl = _extractImageFromDescription(description);
        }

        // Nettoyer la description (enlever HTML)
        description = _cleanHtmlContent(description);

        // Créer l'objet NewsItem
        final newsItem = NewsItem(
          id: id,
          title: title,
          description: description,
          imageUrl: imageUrl,
          date: date,
          link: link,
        );

        newsList.add(newsItem);
      }
    } catch (e) {
      print('Erreur lors de l\'analyse du flux RSS: $e');
    }

    return newsList;
  }

  // Obtenir le texte d'un élément XML
  String _getElementText(XmlElement parent, String elementName) {
    final elements = parent.findElements(elementName);
    if (elements.isNotEmpty) {
      return elements.first.innerText;
    }
    return '';
  }

  // Formater la date RSS
  String _formatRssDate(String rssDate) {
    try {
      final dateTime = DateTime.parse(rssDate);
      final formatter = DateFormat('d MMMM yyyy', 'fr_FR');
      return formatter.format(dateTime);
    } catch (e) {
      return rssDate;
    }
  }

  // Extraire l'URL de l'image de la description HTML
  String _extractImageFromDescription(String htmlContent) {
    // Expression régulière pour trouver l'URL de l'image dans le HTML
    final imgRegex = RegExp(r'<img[^>]+src="([^">]+)"');
    final match = imgRegex.firstMatch(htmlContent);

    if (match != null && match.groupCount >= 1) {
      return match.group(1) ?? '';
    }

    return '';
  }

  // Nettoyer le contenu HTML
  String _cleanHtmlContent(String htmlContent) {
    // Supprimer les balises HTML
    var cleanedText = htmlContent.replaceAll(RegExp(r'<[^>]*>'), '');

    // Décoder les entités HTML
    cleanedText = cleanedText.replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");

    // Supprimer les espaces multiples
    cleanedText = cleanedText.replaceAll(RegExp(r'\s+'), ' ').trim();

    return cleanedText;
  }
}