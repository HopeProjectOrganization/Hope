class Article {
  final String articleId;
  final String title;
  final String link;
  final List<String> keywords;
  final List<String> creator;
  final String description;
  final String? content;
  final String pubDate;
  final String? imageUrl;
  final String? videoUrl;
  final String sourceId;
  final String sourceName;
  final int sourcePriority;
  final String sourceUrl;
  final String? sourceIcon;
  final String language;
  final List<String> country;
  final String category;
  final bool duplicate;

  Article({
    required this.articleId,
    required this.title,
    required this.link,
    required this.keywords,
    required this.creator,
    required this.description,
    this.content,
    required this.pubDate,
    this.imageUrl,
    this.videoUrl,
    required this.sourceId,
    required this.sourceName,
    required this.sourcePriority,
    required this.sourceUrl,
    this.sourceIcon,
    required this.language,
    required this.country,
    required this.category,
    required this.duplicate,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      articleId: json['articleId'] ?? '',
      title: json['title'] ?? 'No title',
      link: json['link'] ?? '',
      keywords: List<String>.from(json['keywords'] ?? []),
      creator: List<String>.from(json['creator'] ?? []),
      description: json['description'] ?? '',
      content: json['content'],
      pubDate: json['pubDate'] ?? '',
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      sourceId: json['sourceId'] ?? '',
      sourceName: json['sourceName'] ?? '',
      sourcePriority: json['sourcePriority'] ?? 0,
      sourceUrl: json['sourceUrl'] ?? '',
      sourceIcon: json['sourceIcon'],
      language: json['language'] ?? 'en',
      country: List<String>.from(json['country'] ?? []),
      category: (json['category'] is String)
          ? json['category']
          : (json['category']?.toString() ?? 'Unknown'),
      duplicate: json['duplicate'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'articleId': articleId,
      'title': title,
      'link': link,
      'keywords': keywords,
      'creator': creator,
      'description': description,
      'content': content,
      'pubDate': pubDate,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'sourceId': sourceId,
      'sourceName': sourceName,
      'sourcePriority': sourcePriority,
      'sourceUrl': sourceUrl,
      'sourceIcon': sourceIcon,
      'language': language,
      'country': country,
      'category': category,
      'duplicate': duplicate,
    };
  }
}
