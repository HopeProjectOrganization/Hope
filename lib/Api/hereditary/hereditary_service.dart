import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/article.dart';
import 'package:http/http.dart' as http;

class HereditaryService {
  static final String baseUrl = "${MyApp.IP}/api/hereditary";

  static Future<List<Article>> getAllNews() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load data");
    }
  }

  static Future<List<Article>> getByCategory(String category) async {
    final url = '$baseUrl/category/$category';
    final response = await http.get(Uri.parse(url));

    print('=== HighRiskService response ===');
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    print('===============================');

    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);

      // تحويل كل عنصر في القائمة إلى Article باستخدام fromJson
      return decoded.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load by category');
    }
  }

  Future<Article> createNews(Article person) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(person.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Article.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create news");
    }
  }

  static Future<void> deleteNews(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Failed to delete news");
    }
  }

  Future<Article> updateNews(int id, Article updated) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updated.toJson()),
    );

    if (response.statusCode == 200) {
      return Article.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update news");
    }
  }
}
