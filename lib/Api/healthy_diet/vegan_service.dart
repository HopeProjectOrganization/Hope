import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/vegan_details.dart';
import 'package:http/http.dart' as http;

class VeganRecipeService {
  static String baseUrl = '${MyApp.IP}/api/vegan-recipes';

  static Future<List<VeganRecipeModel>> getAllRecipes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => VeganRecipeModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load vegan recipes');
    }
  }

  static Future<VeganRecipeModel> getByVeganId(String veganId) async {
    final response = await http.get(Uri.parse('$baseUrl/$veganId'));
    if (response.statusCode == 200) {
      return VeganRecipeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Recipe not found');
    }
  }

  static Future<VeganRecipeModel> getById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/by-id/$id'));
    if (response.statusCode == 200) {
      return VeganRecipeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Recipe not found');
    }
  }

  static Future<VeganRecipeModel> createRecipe(VeganRecipeModel recipe) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(recipe.toJson()),
    );
    if (response.statusCode == 200) {
      return VeganRecipeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create recipe');
    }
  }

  static Future<VeganRecipeModel> updateById(
      int id, VeganRecipeModel recipe) async {
    final response = await http.put(
      Uri.parse('$baseUrl/by-id/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(recipe.toJson()),
    );
    if (response.statusCode == 200) {
      return VeganRecipeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update recipe by id');
    }
  }

  static Future<VeganRecipeModel> updateByVeganId(
      String veganId, VeganRecipeModel recipe) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$veganId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(recipe.toJson()),
    );
    if (response.statusCode == 200) {
      return VeganRecipeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update recipe by veganId');
    }
  }

  static Future<void> deleteById(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/by-id/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete recipe');
    }
  }

  static Future<void> deleteByVeganId(String veganId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$veganId'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete recipe');
    }
  }
}
