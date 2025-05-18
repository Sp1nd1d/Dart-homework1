class Article {
  final String title;
  final String description;
  final String content;
  final String url;
  final String urlToImage;

  Article({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.urlToImage,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
    );
  }
}
