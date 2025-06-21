import 'dart:convert';

import 'package:hope/Api/auth/auth.dart';
import 'package:hope/main.dart';
import 'package:http/http.dart' as http;

class FavoriteApiService {
  static String baseUrl = 'http://${MyApp.IP}/api/favorite-meals';

  static Future<Map<String, String>> getHeaders() async {
    final authService = AuthApiService();
    final token = await authService.getToken();
    if (token == null) {
      throw Exception("User not authenticated.");
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<bool> isFavorite(String id) async {
    final uri = Uri.parse('$baseUrl/$id');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return true; // موجود في المفضلة
    } else if (response.statusCode == 404) {
      return false; // غير موجود
    } else {
      throw Exception('Failed to check favorite status');
    }
  }

  static Future<void> saveFavorite(
      String mealId, String category, String type) async {
    final body = jsonEncode({
      'mealId': mealId,
      'category': category,
      'type': type,
    });

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await getHeaders(),
      body: body,
    );

    if (response.statusCode != 200) {
      print("Error: ${response.statusCode} - ${response.body}");
      throw Exception('Failed to save favorite');
    }
  }

  static Future<List<dynamic>> getByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$baseUrl/category/$category'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load favorites by category');
    }
  }

  static Future<List<dynamic>> getByType(String type) async {
    final response = await http.get(
      Uri.parse('$baseUrl/type/$type'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load favorites by type');
    }
  }

  static Future<dynamic> getById(String mealId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$mealId'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load favorite by id');
    }
  }

  static Future<void> deleteById(String mealId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$mealId'),
      headers: await getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete favorite');
    }
  }

  static Future<void> deleteAll() async {
    final response = await http.delete(
      Uri.parse(baseUrl),
      headers: await getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete all favorites');
    }
  }
}
