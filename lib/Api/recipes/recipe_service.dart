// services/meal_api_service.dart
import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:http/http.dart' as http;

class MealApiService {
  final String _baseUrl = 'https://${MyApp.IP}/api/meals';

  // GET: fetch all meals
  Future<List<Meal>> fetchMeals() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((mealJson) => Meal.fromJson(mealJson)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  // GET: fetch meal by ID
  Future<Meal> fetchMealById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Meal.fromJson(jsonData);
    } else {
      throw Exception('Failed to load meal');
    }
  }

  // POST: save new meal
  Future<Meal> saveMeal(Meal meal) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(meal.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Meal.fromJson(jsonData);
    } else {
      throw Exception('Failed to save meal');
    }
  }

  // PUT: update existing meal
  Future<Meal> updateMeal(String id, Meal updatedMeal) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedMeal.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Meal.fromJson(jsonData);
    } else if (response.statusCode == 404) {
      throw Exception('Meal not found');
    } else {
      throw Exception('Failed to update meal');
    }
  }

  // DELETE: delete meal by ID
  Future<void> deleteMeal(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 204) {
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Meal not found');
    } else {
      throw Exception('Failed to delete meal');
    }
  }
}
