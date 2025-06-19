import 'dart:convert';

import 'package:hope/model/vegan.dart';
import 'package:hope/model/vegan_details.dart';
import 'package:http/http.dart' as http;

//cee3c198b5msh06fb61b0d1e747fp11e9cfjsn1b083226fe05
class VeganService {
  static const String _apiKey =
      'aa2ecc09b9mshf3cdf8257a44f12p1323d0jsn3d495e055b5e';
  static const String _host = 'the-vegan-recipes-db.p.rapidapi.com';

  static Future<List<VeganRecipe>> fetchRecipes() async {
    final url = Uri.parse('https://$_host/');
    final res = await http.get(url, headers: {
      'x-rapidapi-key': _apiKey,
      'x-rapidapi-host': _host,
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data as List).map((e) => VeganRecipe.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  static Future<VeganRecipeDetail> fetchRecipeDetail(String id) async {
    final url = Uri.parse('https://$_host/$id');
    final res = await http.get(url, headers: {
      'x-rapidapi-key': _apiKey,
      'x-rapidapi-host': _host,
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return VeganRecipeDetail.fromJson(data);
    } else {
      throw Exception('Failed to load recipe detail');
    }
  }
}
