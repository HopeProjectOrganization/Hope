import 'dart:convert';

import 'package:hope/Api/recipes/recipe_service.dart';
import 'package:hope/main.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:http/http.dart' as http;

class UserMealService {
  static String baseUrl = 'https://${MyApp.IP}/api/user-meals';

  // POST: حفظ الوجبات
  static Future<void> submitUserMeals({
    required int userId,
    required String category,
    required List<String> mealIds,
    required DateTime dateTime,
  }) async {
    if (category.isEmpty) throw Exception('⚠️ category is empty!');
    if (mealIds.isEmpty) throw Exception('⚠️ mealIds is empty!');

    final url = Uri.parse(baseUrl);
    print('📤 Submitting meals to: $url');

    final body = jsonEncode({
      'userId': userId,
      'category': category,
      'mealIds': mealIds,
      'dateTime': dateTime.toIso8601String(),
    });

    print('📝 Request Body: $body');

    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(url, headers: headers, body: body);

    print('📥 Response Status: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('❌ Failed to submit meals: ${response.body}');
    }
  }

  // GET: استرجاع الوجبات حسب اليوم والفئة
  static Future<List<Meal>> fetchUserMeals({
    required int userId,
    required String category,
    required String date,
  }) async {
    final url = Uri.parse(
        'https://${MyApp.IP}/api/user-meals?userId=$userId&category=${category}&date=$date');

    print('🔍 Fetching meals from: $url');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    print('📥 Response Status: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final mealIds = List<String>.from(data['mealIds']);

      print('📦 Meal IDs fetched: $mealIds');

      List<Meal> meals = [];
      for (String id in mealIds) {
        try {
          print('❌fetching meal by id $id');

          final meal = await MealApiService().fetchMealById(id);
          meals.add(meal);
          print("${meals}");
        } catch (e) {
          print("${url}");
          print('❌ Error fetching meal by id $id: $e');
        }
      }
      print('✅ Total meals loaded: ${meals.length}');
      return meals;
    } else {
      throw Exception('❌ Failed to fetch meals: ${response.body}');
    }
  }
}