class NewsItem {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final String? link;
  static const String defaultImageUrl = 'assets/images/news_placeholder.png';

  NewsItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    this.link,
  });

  // Vérifie si une image est disponible
  bool get hasImage => imageUrl.isNotEmpty;

  // Obtient l'URL de l'image ou l'image par défaut
  String get displayImageUrl => hasImage ? imageUrl : defaultImageUrl;

  // Factory pour créer à partir de JSON (pour compatibilité)
  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'] ?? '',
      date: json['date'],
      link: json['link'],
    );
  }

  // Conversion en JSON (pour compatibilité)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'date': date,
      'link': link,
    };
  }
}