import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserMealService {
  /// ⬇️ إرسال وجبات المستخدم إلى السيرفر (POST)
  static Future<void> submitUserMeals({
    required int userId,
    required String category,
    required List<String> mealIds,
  }) async {
    final url = Uri.parse('https://${MyApp.IP}/api/user-meals');
    final now = DateTime.now();

    final body = {
      'userId': userId,
      'dateTime': now.toIso8601String(),
      'category': category.toLowerCase(),
      'mealIds': mealIds,
    };

    print('🚀 Sending request to: $url');
    print('📦 Payload: $body');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    print('📨 Response status: ${response.statusCode}');
    print('📨 Response body: "${response.body}"');

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isNotEmpty) {
        try {
          final data = json.decode(response.body);
          print('📦 Response JSON parsed: $data');
        } catch (e) {
          print('⚠️ Warning: response body is not valid JSON: $e');
        }

        final prefs = await SharedPreferences.getInstance();
        final today = DateTime.now();
        final key = "${today.year}-${today.month}-${today.day}";
        await prefs.setBool("mealAdded_$key", true);
        print('✅ Saved meal flag for today');
      } else {
        print('ℹ️ Response body is empty');
      }
      print('✅ Meals submitted successfully');
    } else {
      print('❌ Failed to submit meals: ${response.statusCode}');
      throw Exception('API submission failed');
    }
  }

  /// ⬇️ جلب الوجبات حسب التاريخ والفئة (GET)
  static Future<List<Meal>> fetchMealsByCategoryAndDate({
    required String category,
    DateTime? date,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId");

    if (userId == null) throw Exception("User ID not found");

    final now = date ?? DateTime.now();
    final formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final url = Uri.parse(
      'https://${MyApp.IP}/api/user-meals?userId=$userId&category=${category.toLowerCase()}&date=$formattedDate',
    );

    print("📡 Fetching meals from: $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final mealsJson = data['meals'] as List;
      return mealsJson.map((meal) => Meal.fromJson(meal)).toList();
    } else {
      print("❌ Failed to fetch meals: ${response.statusCode}");
      throw Exception('Failed to fetch meals');
    }
  }
}
