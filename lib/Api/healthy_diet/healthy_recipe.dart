import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/model/res_model.dart';
import 'package:http/http.dart' as http;

class MealService {
  static Future<List<RecModel>> getAllMeals(BuildContext context) async {
    final url =
    Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final List meals = decoded['meals'] ?? [];

        return meals.map((e) => RecModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      debugPrint('Error loading meals: $e');
      return [];
    }
  }

  static Future<List<RecModel>> getCategories(BuildContext context) async {
    final url =
    Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List cats = decoded['categories'] ?? [];
        return cats.map((e) => RecModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
      return [];
    }
  }

  static Future<List<RecModel>> getMealsByCategory(String category) async {
    final url = Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List meals = decoded['meals'] ?? [];

        return meals.map((e) => RecModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load meals by category');
      }
    } catch (e) {
      debugPrint('Error loading meals by category: $e');
      return [];
    }
  }

  static Future<RecModel?> getMealDetailsById(String mealId) async {
    final url = Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final data = decoded['meals']?[0];

      if (data == null) return null;

      return RecModel.fromJson(data);
    } else {
      throw Exception('Failed to load meal details');
    }
  }
}
