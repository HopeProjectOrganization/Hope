import 'dart:convert';

import 'package:hope/model/article_dm.dart';
import 'package:http/http.dart' as http;

class NewsService {
  static Future<List<ArticleDM>> fetchNews(String cancerType, String apiKey,
      bool news) async {
    List<ArticleDM> externalArticles = await fetchExternalNews(
        cancerType, apiKey, news);
    List<ArticleDM> localArticles = await fetchLocalNews(cancerType);

    return [...localArticles, ...externalArticles];
  }

  static Future<List<ArticleDM>> fetchExternalNews(String cancerType,
      String apiKey, bool news) async {
    String query = "${Uri.encodeComponent(cancerType)} cancer";
    final url = Uri.parse(
        "https://newsapi.org/v2/everything?q=$query&language=en&apiKey=$apiKey");

    final response = await http.get(url);
    print("Response: ${response.body}");

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

      return news == true ? filteredArticles : articles;
    } else {
      throw Exception("Failed to load news from external API");
    }
  }

  static Future<List<ArticleDM>> fetchLocalNews(String cancerType) async {
    final url = Uri.parse(
        "http://192.168.78.153:8080/api/news/all?category=$cancerType");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData == null) {
        return [];
      }

      List<ArticleDM> articles = List.from(jsonData).map((data) {
        return ArticleDM.fromJson(data);
      }).toList();

      return articles;
    } else {
      throw Exception("Failed to load local news");
    }
  }

  Future<void> addNews(ArticleDM article, String category) async {
    final url = Uri.parse("http://192.168.78.153:8080/api/news/add");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": article.title,
        "content": article.content,
        "category": category,
        "imageUrl": article.url,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to add news");
    }
  }

  Future<void> editNews(int id, ArticleDM article, String category) async {
    final url = Uri.parse("http://192.168.78.153:8080/api/news/edit/$id");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": article.title,
        "content": article.content,
        "category": category,
        "imageUrl": article.url,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to edit news");
    }
  }
}
