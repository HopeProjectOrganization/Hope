class Article {
  final String articleId;
  final String title;
  final String link;
  final List<String>? keywords;
  final List<String>? creator;
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
  final List<String> category;
  final bool duplicate;

  Article({
    required this.articleId,
    required this.title,
    required this.link,
    this.keywords,
    this.creator,
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
      articleId: json['article_id'] ?? '',
      title: json['title'] ?? 'No title',
      link: json['link'] ?? '',
      keywords: (json['keywords'] as List?)?.map((e) => e.toString()).toList(),
      creator: (json['creator'] as List?)?.map((e) => e.toString()).toList(),
      description: json['description'] ?? '',
      content: json['content'],
      pubDate: json['pubDate'] ?? '',
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
      sourceId: json['source_id'] ?? '',
      sourceName: json['source_name'] ?? '',
      sourcePriority: json['source_priority'] ?? 0,
      sourceUrl: json['source_url'] ?? '',
      sourceIcon: json['source_icon'],
      language: json['language'] ?? 'en',
      country: List<String>.from(json['country'] ?? []),
      category: List<String>.from(json['category'] ?? []),
      duplicate: json['duplicate'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'article_id': articleId,
      'title': title,
      'link': link,
      'keywords': keywords,
      'creator': creator,
      'description': description,
      'content': content,
      'pubDate': pubDate,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'source_id': sourceId,
      'source_name': sourceName,
      'source_priority': sourcePriority,
      'source_url': sourceUrl,
      'source_icon': sourceIcon,
      'language': language,
      'country': country,
      'category': category,
      'duplicate': duplicate,
    };
  }
}
