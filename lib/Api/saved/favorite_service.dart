import 'dart:convert';

import 'package:hope/Api/auth/auth.dart';
import 'package:hope/main.dart';
import 'package:hope/model/favorite.dart';
import 'package:http/http.dart' as http;

class FavoriteApiService {
  static String baseUrl = 'https://${MyApp.IP}/api/favorite-meals';

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

  static Future<bool> isFavorite(String mealId) async {
    final uri = Uri.parse('$baseUrl/$mealId');
    final response = await http.get(
      uri,
      headers: await getHeaders(),
    );
    print("Favorite check status: ${response.statusCode}");

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Failed to check favorite status');
    }
  }

  static Future<void> saveFavorite(String mealId, String category,
      String type) async {
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
      throw Exception('Failed to save favorite: ${response.body}');
    }
  }

  static Future<List<FavoriteMeal>> getByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$baseUrl/category/$category'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => FavoriteMeal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load favorites by category');
    }
  }

  static Future<List<FavoriteMeal>> getByType(String type) async {
    final response = await http.get(
      Uri.parse('$baseUrl/type/$type'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => FavoriteMeal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load favorites by type');
    }
  }

  static Future<List<FavoriteMeal>> getFavoritesByType(String type) async {
    final url = Uri.parse('$baseUrl/type/$type');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => FavoriteMeal.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch favorites by type');
    }
  }

  static Future<List<FavoriteMeal>> getAllFavorites() async {
    List<FavoriteMeal> all = [];
    for (String cat in [
      'NEWS',
      'HEREDITARY',
      'HIGH_RISK_PEOPLE',
      'MEALSENSE',
      'HEALTHY_DIET',
      'VEGAN',
      'EXERCISE'
    ]) {
      final list = await getByCategory(cat);
      all.addAll(list);
    }
    return all;
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
}
