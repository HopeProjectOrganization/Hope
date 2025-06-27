import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/article.dart';
import 'package:http/http.dart' as http;

class NewsApiService {
  final String baseUrl = 'https://${MyApp.IP}/api/news';

  // إضافة خبر جديد
  static Future<Article> addNews(Article article) async {
    final String baseUrl = 'https://${MyApp.IP}/api/news';
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(article.toJson()),
    );

    if (response.statusCode == 200) {
      return Article.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('فشل في إضافة الخبر');
    }
  }

  // جلب الأخبار حسب الكاتيجوري
  static Future<List<Article>> getNewsByCategory(String category) async {
    final String baseUrl = 'https://${MyApp.IP}/api/news';

    final response = await http.get(Uri.parse('$baseUrl/$category'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print(response.body);
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('فشل في جلب الأخبار');
    }
  }

  // حذف خبر
  static Future<void> deleteNews(int id) async {
    final String baseUrl = 'https://${MyApp.IP}/api/news';
    final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));

    if (response.statusCode != 200) {
      throw Exception('فشل في حذف الخبر');
    }
  }

  // تعديل خبر
  Future<Article> updateNews(int id, Article article) async {
    final response = await http.put(
      Uri.parse('$baseUrl/edit/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(article.toJson()),
    );

    if (response.statusCode == 200) {
      return Article.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('فشل في تعديل الخبر');
    }
  }
}
