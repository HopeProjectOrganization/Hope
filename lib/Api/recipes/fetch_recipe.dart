import 'dart:convert';

import 'package:hope/model/meal_dm.dart';
import 'package:http/http.dart' as http;

Future<List<Meal>> fetchMeal() async {
  final url = Uri.parse(
      'https://keto-diet.p.rapidapi.com/?protein_in_grams__lt=15&protein_in_grams__gt=5');

  final response = await http.get(
    url,
    headers: {
      'x-rapidapi-host': 'keto-diet.p.rapidapi.com',
      'x-rapidapi-key': '98e3c41bdamsh6960eb2e07a8eabp1de9ecjsn02d167280bf6',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Meal.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load meals from RapidAPI');
  }
}

Future<Meal> fetchMealById(int id) async {
  final url = Uri.parse('https://keto-diet.p.rapidapi.com/?id=$id');

  final response = await http.get(
    url,
    headers: {
      'x-rapidapi-host': 'keto-diet.p.rapidapi.com',
      'x-rapidapi-key': '98e3c41bdamsh6960eb2e07a8eabp1de9ecjsn02d167280bf6',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    // لو الرد عبارة عن List فيها عنصر واحد:
    if (data is List && data.isNotEmpty) {
      return Meal.fromJson(data[0]);
    } else {
      throw Exception('Meal not found with ID $id');
    }
  } else {
    throw Exception('Failed to load meal with ID $id');
  }
}
