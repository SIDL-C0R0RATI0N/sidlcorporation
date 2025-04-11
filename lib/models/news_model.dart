class NewsItem {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final String? link;

  NewsItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    this.link,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      date: json['date'],
      link: json['link'],
    );
  }

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