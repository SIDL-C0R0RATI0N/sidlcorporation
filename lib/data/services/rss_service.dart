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
          final content = _getElementText(item, 'content:encoded');

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
      return [];
    }
  }

  String _getElementText(XmlElement item, String elementName) {
    final elements = item.findElements(elementName);
    return elements.isNotEmpty ? elements.first.innerText : '';
  }

  DateTime _parseDate(String dateString) {
    try {
      return DateFormat('EEE, dd MMM yyyy HH:mm:ss Z').parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
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
}