import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/high_risk_ingredents.dart';
import 'package:http/http.dart' as http;

class HighRiskIngredientService {
  static final String _baseUrl =
      '${MyApp.IP}/api/high-risk-ingredients';

  static Future<List<HighRiskIngredient>> getAll() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => HighRiskIngredient.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load ingredients');
    }
  }

  static Future<void> create(HighRiskIngredient ingredient) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ingredient.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add ingredient');
    }
  }

  static Future<void> update(int id, HighRiskIngredient ingredient) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ingredient.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update ingredient');
    }
  }

  static Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete ingredient');
    }
  }
}
