class NewsItem {
  final String title;
  final String link;
  final String creator;
  final DateTime pubDate;
  final String content;
  final String imageUrl;

  NewsItem({
    required this.title,
    required this.link,
    required this.creator,
    required this.pubDate,
    required this.content,
    required this.imageUrl,
  });
}