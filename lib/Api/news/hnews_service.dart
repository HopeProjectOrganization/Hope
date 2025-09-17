import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/article.dart';
import 'package:http/http.dart' as http;

class HealthyDietService {
  static final String baseUrl = 'https://${MyApp.IP}/api/diet';

  // جلب كل الدايتس
  static Future<List<Article>> getAllDiets() async {
    final response = await http.get(Uri.parse('${MyApp.IP}/api/diet'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Article.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load diets');
    }
  }

  // جلب حسب "category" = videoUrl
  static Future<List<Article>> getByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/category/$category'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Article.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch by category');
    }
  }

  // إنشاء دايت جديد
  Future<void> createDiet(Article diet) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(diet.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create diet: ${response.body}');
    }
  }
}
