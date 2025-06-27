import 'dart:convert';

import 'package:hope/Api/recipes/recipe_service.dart';
import 'package:hope/main.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserMeal {
  final String category;
  final DateTime date;
  final String mealId;

  UserMeal({
    required this.category,
    required this.date,
    required this.mealId,
  });

  factory UserMeal.fromJson(Map<String, dynamic> json) {
    return UserMeal(
      category: json['category'],
      date: DateTime.parse(json['date']),
      mealId: json['mealIds'][0], // لو أكتر من وجبة بتحتاجي تغيري دا
    );
  }
}

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
    final prefs = await SharedPreferences.getInstance();
    final todayKey = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
    await prefs.setBool("mealAdded_$todayKey", true);
  }

  // ✅ GET: استرجاع الوجبات كـ UserMeal (مع date و mealId)
  static Future<List<UserMeal>> fetchUserMealsAsUserMeal({
    required int userId,
    required String category,
    required String date,
  }) async {
    final url = Uri.parse(
        'https://${MyApp.IP}/api/user-meals?userId=$userId&category=$category&date=$date');

    print('🔍 Fetching user meals from: $url');
    print("📅 FETCHING MEALS FOR DATE: $date");

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    print('📥 Response Status: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    print("✅ FINAL URL: $url");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<String> mealIds = List<String>.from(data['mealIds']);

      return mealIds
          .map((id) => UserMeal(
                category: category,
                date: DateTime.parse(date),
                mealId: id,
              ))
          .toList();
    } else {
      throw Exception('❌ Failed to fetch user meals: ${response.body}');
    }
  }

  // ✅ تحميل تفاصيل الوجبات بناءً على UserMeal
  static Future<List<Meal>> fetchMealsFromUserMeals(
      List<UserMeal> userMeals) async {
    List<Meal> meals = [];

    for (var userMeal in userMeals) {
      try {
        final meal = await MealApiService().fetchMealById(userMeal.mealId);
        meal.date = userMeal.date; // ✅ حفظ التاريخ داخل الـ Meal
        meals.add(meal);
      } catch (e) {
        print('❌ Error fetching meal by id ${userMeal.mealId}: $e');
      }
    }

    return meals;
  }

  // ❌ DELETE: حذف وجبة معينة من فئة و تاريخ محدد
  static Future<void> deleteUserMeal({
    required int userId,
    required String date,
    required String category,
    required String mealId,
  }) async {
    final url = Uri.parse(
        'https://${MyApp.IP}/api/user-meals?userId=$userId&date=$date&category=$category&mealId=$mealId');

    print('🗑️ Deleting user meal: $url');

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    print('📥 Response Status: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode != 204) {
      throw Exception('❌ Failed to delete meal: ${response.body}');
    }
  }
}
