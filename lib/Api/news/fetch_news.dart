import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/article_dm.dart';
import 'package:hope/model/news_model.dart';
import 'package:http/http.dart' as http;

class NewsService {
  static Future<List<ArticleDM>> fetchNews(
      String cancerType) async {
    List<ArticleDM> externalArticles =
        await fetchExternalNews(cancerType);
    List<ArticleDM> localArticles = await fetchLocalNews(cancerType);
    return [...localArticles, ...externalArticles];
    // return externalArticles;
  }

  static Future<List<ArticleDM>> fetchExternalNews(
      String cancerType) async {
    String query = "${Uri.encodeComponent(cancerType)} cancer";
    final url = Uri.parse(
        "https://real-time-news-data.p.rapidapi.com/search?query=$query&limit=10&time_published=anytime&country=EG");

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
        final pattern =
            RegExp(r'\b' + RegExp.escape(cancerType.toLowerCase()) + r'\b');
        return pattern.hasMatch(title);
      }).toList();

      return  articles;
    } else {
      throw Exception("Failed to load news from external API");
    }
  }

  static Future<List<ArticleDM>> fetchLocalNews(String cancerType) async {
    final url =
        Uri.parse("${MyApp.IP}/api/news/all?category=$cancerType");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData == null) {
        return [];
      }

      List<ArticleDM> articles = List.from(jsonData).map((data) {
        NewsModel model = NewsModel.fromJson(data);
        return ArticleDM(
          title: model.title,
          content: model.content,
          url: model.imageUrl, // Assuming this is where image goes
          // باقي الخصائص حسب اللي موجود في ArticleDM
        );
      }).toList();

      return articles;
    } else {
      throw Exception("Failed to load local news");
    }
  }
//
// Future<void> addNews(ArticleDM article, String category) async {
//   final url = Uri.parse("http://192.168.1.31:8081/api/news/add");
//   final response = await http.post(
//     url,
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode({
//       "title": article.title,
//       "content": article.content,
//       "category": category,
//       "imageUrl": article.url,
//     }),
//   );
//
//   if (response.statusCode != 200) {
//     throw Exception("Failed to add news");
//   }
// }
//
// Future<void> editNews(int id, ArticleDM article, String category) async {
//   final url = Uri.parse("http://192.168.1.31:8081/api/news/edit/$id");
//   final response = await http.put(
//     url,
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode({
//       "title": article.title,
//       "content": article.content,
//       "category": category,
//       "imageUrl": article.url,
//     }),
//   );
//
//   if (response.statusCode != 200) {
//     throw Exception("Failed to edit news");
//   }
// }
}
