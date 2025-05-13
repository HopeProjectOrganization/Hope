class NewsModel {
  final int? id;
  final String? title;
  final String? content;
  final String? category;
  final String? imageUrl;

  NewsModel({
    this.id,
    this.title,
    this.content,
    this.category,
    this.imageUrl,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'imageUrl': imageUrl,
    };
  }
}
