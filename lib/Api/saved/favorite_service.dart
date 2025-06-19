import 'dart:convert';

import 'package:hope/main.dart';
import 'package:http/http.dart' as http;

class FavoriteApiService {
  static String baseUrl = 'http://${MyApp.IP}/api/favorite-meals';
  static const String token =
      'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJiYXNzZWxAZ21haWwuY29tIiwiaWF0IjoxNzUwMjk3MTE2LCJleHAiOjE3NTA1NTYzMTZ9.btgUCRk12qLPfs4apneerqlcSVMzECwXc_cwpfRXGmg'; // <<< حطي هنا التوكن اللي معاكِ

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  static Future<bool> isFavorite(String id) async {
    final uri = Uri.parse('$baseUrl/$id');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true; // موجود في المفضلة
    } else if (response.statusCode == 404) {
      return false; // غير موجود
    } else {
      throw Exception('Failed to check favorite status');
    }
  }

  // Save Favorite
  static Future<void> saveFavorite(
      String mealId, String category, String type) async {
    final body = jsonEncode({
      'mealId': mealId,
      'category': category,
      'type': type,
    });

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      print("Error: ${response.statusCode} - ${response.body}");
      throw Exception('Failed to save favorite');
    }
  }

  // Get Favorites by Category
  static Future<List<dynamic>> getByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$baseUrl/category/$category'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load favorites by category');
    }
  }

  // Get Favorites by Type
  static Future<List<dynamic>> getByType(String type) async {
    final response = await http.get(
      Uri.parse('$baseUrl/type/$type'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load favorites by type');
    }
  }

  // Get Favorite by MealId
  static Future<dynamic> getById(String mealId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$mealId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load favorite by id');
    }
  }

  // Delete Favorite by MealId
  static Future<void> deleteById(String mealId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$mealId'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete favorite');
    }
  }

  // Delete All Favorites
  static Future<void> deleteAll() async {
    final response = await http.delete(
      Uri.parse(baseUrl),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete all favorites');
    }
  }
}
