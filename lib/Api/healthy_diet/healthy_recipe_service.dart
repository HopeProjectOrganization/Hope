import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/healthy_recipes.dart';
import 'package:http/http.dart' as http;

class RecipeService {
  static String baseUrl = 'https://${MyApp.IP}/api/recipes';

  static Future<List<RecipeModel>> getAllRecipes() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch recipes');
    }
  }

  static Future<RecipeModel> getRecipeById(String recipeId) async {
    final response = await http.get(Uri.parse('$baseUrl/$recipeId'));

    if (response.statusCode == 200) {
      return RecipeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Recipe not found');
    }
  }

  static Future<void> createRecipe(RecipeModel recipe) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(recipe.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create recipe');
    }
  }

  static Future<void> updateRecipe(int id, RecipeModel recipe) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'), // ⬅️ ده id الأوتوماتيك
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(recipe.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update recipe');
    }
  }

  static Future<void> deleteRecipe(String recipeId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$recipeId'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete recipe');
    }
  }
}
