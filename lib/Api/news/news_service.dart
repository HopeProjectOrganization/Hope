import 'dart:convert';

import 'package:hope/model/article_dm.dart';
import 'package:http/http.dart' as http;

class NewsService {
  static Future<List<ArticleDM>> fetchNews(
      String cancerType, String apiKey) async {
    String query = "${Uri.encodeComponent(cancerType)} cancer";
    final url = Uri.parse(
        "https://newsapi.org/v2/everything?q=$query&language=en&apiKey=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData["articles"] == null) {
        return [];
      }
      List<ArticleDM> articles = List.from(jsonData["articles"]).map((data) {
        return ArticleDM.fromJson(data);
      }).toList();
      List<ArticleDM> filteredArticles = articles.where((article) {
        String title = (article.title ?? "").toLowerCase();
        return title.contains(cancerType.toLowerCase());
      }).toList();

      return filteredArticles;
    } else {
      throw Exception("Failed to load news");
    }
  }
}
