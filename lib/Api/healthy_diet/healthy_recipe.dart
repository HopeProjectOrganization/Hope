import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MealService {
  static Future<List<dynamic>> getAllMeals(BuildContext context) async {
    final url =
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['meals'] ?? [];
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      debugPrint('Error loading meals: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getCategories(BuildContext context) async {
    final url =
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['categories'] ?? [];
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getMealsByCategory(String category) async {
    final url = Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['meals'] ?? [];
      } else {
        throw Exception('Failed to load meals by category');
      }
    } catch (e) {
      debugPrint('Error loading meals by category: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getMealDetailsById(String mealId) async {
    final url = Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['meals']?[0];
    } else {
      throw Exception('Failed to load meal details');
    }
  }
}
