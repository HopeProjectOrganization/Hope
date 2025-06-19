// services/meal_api_service.dart
import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:http/http.dart' as http;

class MealApiService {
  final String _baseUrl = 'http://${MyApp.IP}/api/meals';

  Future<List<Meal>> fetchMeals() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((mealJson) => Meal.fromJson(mealJson)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }
}

Future<Meal> fetchMealById(String id) async {
  String baseUrl = 'http://${MyApp.IP}';
  final url = Uri.parse('$baseUrl/api/meals/$id');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return Meal.fromJson(json);
  } else {
    throw Exception('Failed to load meal');
  }
}
