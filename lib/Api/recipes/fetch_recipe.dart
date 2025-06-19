// import 'dart:convert';
//
// import 'package:hope/model/meal_dm.dart';
// import 'package:http/http.dart' as http;
//
// const _headers = {
//   'x-rapidapi-host': 'keto-diet.p.rapidapi.com',
//   'x-rapidapi-key': '57e13c220cmshcaeaeb6bce048d6p104a40jsnda816a6b4e17',
// };
//
// Future<List<Meal>> fetchMeals() async {
//   final url = Uri.parse('https://keto-diet.p.rapidapi.com/');
//   final response = await http.get(url, headers: _headers);
//
//   if (response.statusCode == 200) {
//     final List<dynamic> data = json.decode(response.body);
//     return data.map((json) => Meal.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load meals from RapidAPI');
//   }
// }
//
// Future<Meal> fetchMealById(int id) async {
//   final url = Uri.parse('https://keto-diet.p.rapidapi.com/?id=$id');
//   final response = await http.get(url, headers: _headers);
//
//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     if (data is List && data.isNotEmpty) {
//       return Meal.fromJson(data[0]);
//     } else {
//       throw Exception('Meal not found with ID $id');
//     }
//   } else {
//     throw Exception('Failed to load meal with ID $id');
//   }
// }
//
// Future<List<Meal>> fetchMealsBySearch(String query) async {
//   final url = Uri.parse('https://keto-diet.p.rapidapi.com/?search=$query');
//   final response = await http.get(url, headers: _headers);
//
//   if (response.statusCode == 200) {
//     final List<dynamic> data = json.decode(response.body);
//     return data.map((json) => Meal.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to search meals from RapidAPI');
//   }
// }
//
// class Category {
//   final int id;
//   final String category;
//   final String thumbnail;
//
//   Category({required this.id, required this.category, required this.thumbnail});
//
//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       id: json['id'],
//       category: json['category'],
//       thumbnail: json['thumbnail'],
//     );
//   }
// }
//
// Future<List<Category>> getCategories() async {
//   final response = await http.get(
//     Uri.parse('https://keto-diet.p.rapidapi.com/categories/'),
//     headers: _headers,
//   );
//
//   if (response.statusCode == 200) {
//     final List<dynamic> data = json.decode(response.body);
//     return data.map((json) => Category.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load categories');
//   }
// }
//
// Future<List<Meal>> getMealsByCategory(String categoryId) async {
//   final response = await http.get(
//     Uri.parse('https://keto-diet.p.rapidapi.com/?category=$categoryId'),
//     headers: _headers,
//   );
//
//   if (response.statusCode == 200) {
//     final List<dynamic> data = json.decode(response.body);
//     return data.map((json) => Meal.fromJson(json)).toList();
//   } else {
//     throw Exception('Failed to load meals for category');
//   }
// }

import 'dart:convert';

import 'package:hope/model/meal_dm.dart';
import 'package:http/http.dart' as http;

const _headers = {
  'x-rapidapi-host': 'low-carb-recipes.p.rapidapi.com',
  'x-rapidapi-key': '57e13c220cmshcaeaeb6bce048d6p104a40jsnda816a6b4e17',
};

Future<List<Meal>> fetchRecipes() async {
  final url =
      Uri.parse('https://low-carb-recipes.p.rapidapi.com/search?limit=20');
  final response = await http.get(url, headers: _headers);

  if (response.statusCode == 200) {
    final body = response.body;
    print("📦 API Raw Response: $body");

    final decoded = json.decode(body);

    if (decoded is List) {
      return decoded
          .whereType<Map<String, dynamic>>()
          .map((json) => Meal.fromJson(json))
          .toList();
    } else {
      print("❗ Unexpected JSON structure: $decoded");
      throw Exception("Unexpected response format: Not a List");
    }
  } else {
    throw Exception('Failed to load recipes from RapidAPI');
  }
}

Future<Meal> fetchMealById(String id) async {
  final response = await http.get(
    Uri.parse('https://low-carb-recipes.p.rapidapi.com/recipes/$id'),
    headers: _headers,
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // ✅ هنا بيرجع مباشرة كائن الوجبة، مش جوه List
    return Meal.fromJson(data);
  } else {
    throw Exception('Failed to load meal');
  }
}
