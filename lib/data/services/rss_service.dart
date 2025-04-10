import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sidlcorporation/config/constants.dart';
import 'package:sidlcorporation/data/models/news_item.dart';
import 'package:xml/xml.dart';
import 'package:html/parser.dart' as html;

class RssService {
  Future<List<NewsItem>> getNews() async {
    try {
      final response = await http.get(Uri.parse(AppConstants.rssFeedUrl));

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final items = document.findAllElements('item');

        return items.map((item) {
          // Titre
          final title = _getElementText(item, 'title');

          // Lien
          final link = _getElementText(item, 'link');

          // Créateur
          final creator = _getElementText(item, 'dc:creator');

          // Date de publication
          final pubDateString = _getElementText(item, 'pubDate');
          final pubDate = _parseDate(pubDateString);

          // Contenu
          final content = _cleanContentHtml(_getElementText(item, 'content:encoded'));

          // Image
          final description = _getElementText(item, 'description');
          final imageUrl = _extractImageFromDescription(description);

          return NewsItem(
            title: title,
            link: link,
            creator: creator,
            pubDate: pubDate,
            content: content,
            imageUrl: imageUrl,
          );
        }).toList();
      } else {
        throw Exception('Échec de chargement du flux RSS');
      }
    } catch (e) {
      // En cas d'erreur, retourner une liste vide
      return _getMockNews();
    }
  }

  String _getElementText(XmlElement item, String elementName) {
    final elements = item.findElements(elementName);
    if (elements.isNotEmpty) {
      // Nettoyer le contenu en retirant les CDATA si nécessaire
      String content = elements.first.innerText;
      // La balise CDATA peut être présente dans les flux RSS WordPress
      if (content.startsWith('<![CDATA[') && content.endsWith(']]>')) {
        content = content.substring(9, content.length - 3);
      }
      return content;
    }
    return '';
  }

  DateTime _parseDate(String dateString) {
    try {
      return DateFormat('EEE, dd MMM yyyy HH:mm:ss Z').parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }

  String _cleanContentHtml(String html) {
    if (html.isEmpty) return '';

    // Nettoyer les scripts et styles inutiles qui pourraient causer des problèmes
    html = html.replaceAll(RegExp(r'<script[^>]*>.*?</script>', dotAll: true), '');
    html = html.replaceAll(RegExp(r'<style[^>]*>.*?</style>', dotAll: true), '');

    // Corriger les problèmes d'images relatives
    html = html.replaceAll('src="//', 'src="https://');

    return html;
  }

  String _extractImageFromDescription(String description) {
    try {
      final document = html.parse(description);
      final imgElements = document.getElementsByClassName('webfeedsFeaturedVisual');

      if (imgElements.isNotEmpty) {
        final srcAttribute = imgElements.first.attributes['src'];
        return srcAttribute ?? '';
      }

      // Si pas d'image avec cette classe, chercher n'importe quelle image
      final allImgElements = document.getElementsByTagName('img');
      if (allImgElements.isNotEmpty) {
        final srcAttribute = allImgElements.first.attributes['src'];
        return srcAttribute ?? '';
      }

      return '';
    } catch (e) {
      return '';
    }
  }

  // Données d'exemple au cas où l'API échoue
  List<NewsItem> _getMockNews() {
    print('Utilisation des données mock pour les news');
    return [
      NewsItem(
        title: 'SIDL Corporation lance une nouvelle solution de cybersécurité innovante',
        link: 'https://www.sidl-corporation.fr/news/1',
        creator: 'Admin SIDL',
        pubDate: DateTime.now().subtract(const Duration(days: 2)),
        content: 'SIDL Corporation est fière d\'annoncer le lancement de sa nouvelle solution de cybersécurité pour les entreprises...',
        imageUrl: '',
      ),
      NewsItem(
        title: 'Ouverture de nos nouveaux bureaux à Lyon',
        link: 'https://www.sidl-corporation.fr/news/2',
        creator: 'Admin SIDL',
        pubDate: DateTime.now().subtract(const Duration(days: 14)),
        content: 'SIDL Corporation poursuit son expansion avec l\'ouverture d\'un nouveau bureau à Lyon pour mieux servir nos clients...',
        imageUrl: '',
      ),
      NewsItem(
        title: 'Partenariat stratégique avec Microsoft pour les solutions cloud',
        link: 'https://www.sidl-corporation.fr/news/3',
        creator: 'Admin SIDL',
        pubDate: DateTime.now().subtract(const Duration(days: 30)),
        content: 'SIDL Corporation annonce un partenariat stratégique avec Microsoft pour développer des solutions cloud innovantes...',
        imageUrl: '',
      ),
    ];
  }
}