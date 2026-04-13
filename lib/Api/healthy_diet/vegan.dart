import 'dart:convert';
import 'package:hope/model/vegan_details.dart';
import 'package:http/http.dart' as http;

class VeganService {
  static const String _apiKey =
      '4ea486f67cmsh36dda55eb08f629p144934jsn554ab963c9f3';
  static const String _host = 'the-vegan-recipes-db.p.rapidapi.com';

  static const String _baseUrl =
      'https://the-vegan-recipes-db.p.rapidapi.com';

  static Future<List<VeganRecipeModel>> fetchRecipes() async {
    final url = Uri.parse('$_baseUrl/');

    final res = await http.get(url, headers: {
      'x-rapidapi-key': _apiKey,
      'x-rapidapi-host': _host,
    });

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);

      final List data = decoded is List ? decoded : decoded['data'];

      return data
          .map((e) => VeganRecipeModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  static Future<VeganRecipeModel> fetchRecipeDetail(String id) async {
    final url = Uri.parse('$_baseUrl/$id');

    final res = await http.get(url, headers: {
      'x-rapidapi-key': _apiKey,
      'x-rapidapi-host': _host,
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return VeganRecipeModel.fromJson(data);
    } else {
      throw Exception('Failed to load recipe detail');
    }
  }
}