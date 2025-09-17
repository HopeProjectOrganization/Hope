// services/meal_api_service.dart
import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:http/http.dart' as http;

class MealApiService {
  final String _baseUrl = '${MyApp.IP}/api/meals';

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

  Future<Meal> fetchMealById(String id) async {
    final url = Uri.parse(
        'https://${MyApp.IP}/api/meals/$id'); // ✅ رابط backend مش RapidAPI
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Meal.fromJson(data); // ✅ تأكدي هنا من الشكل
    } else {
      throw Exception('Failed to load meal');
    }
  }

  Future<Meal> saveMeal(Meal meal) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(meal.toJson()),
    );

    print("POST BODY: ${json.encode(meal.toJson())}");
    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      return Meal.fromJson(jsonData);
    } else {
      throw Exception('Failed to save meal. Code: ${response.statusCode}');
    }
  }

  Future<Meal> updateMeal(String id, Meal updatedMeal) async {
    final url = Uri.parse('$_baseUrl/$id');
    final payload = json.encode(updatedMeal.toJson());

    print("📤 Updating meal with ID: $id");
    print("➡️ URL: $url");
    print("➡️ Payload: $payload");

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: payload,
    );

    print("📬 Status Code: ${response.statusCode}");
    print("📬 Response Body: ${response.body}");

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
