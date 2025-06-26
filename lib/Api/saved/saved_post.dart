import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/article.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SavedPostService {
  static Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  static Future<bool> isFavorite(String mealId) async {
    final uri = Uri.parse(
        'https://${MyApp.IP}/api/favorites/$mealId'); // <-- هذا الصحيح
    final response = await http.get(uri, headers: await getHeaders());
    print("Favorite check status: ${response.statusCode}");

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Failed to check favorite status');
    }
  }

  static Future<bool> addToSaved({
    required int postId,
    required String postStringId,
    required String postType,
  }) async {
    final url = Uri.parse('https://${MyApp.IP}/api/favorites/add');

    final response = await http.post(
      url,
      headers: await getHeaders(),
      body: jsonEncode({
        "postId": postId,
        "postStringId": postStringId,
        "postType": postType,
      }),
    );
    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");

    return response.statusCode == 200;
  }

  static Future<List<Article>> fetchSavedArticles(String category) async {
    final url =
        Uri.parse('https://${MyApp.IP}/api/favorites/by-type/$category');

    final response = await http.get(url, headers: await getHeaders());

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      throw Exception('فشل في تحميل المقالات المحفوظة من $category');
    }
  }

  static Future<bool> deleteFavorite({
    required int postId,
    required String postType,
  }) async {
    final url = Uri.parse('https://${MyApp.IP}/api/favorites/delete');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "postId": postId,
        "postType": postType,
      }),
    );

    return response.statusCode == 200;
  }
}
