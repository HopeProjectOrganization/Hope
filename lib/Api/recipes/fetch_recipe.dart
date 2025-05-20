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

Future<List<Meal>> fetchMealsBySearch(String query) async {
  final url = Uri.parse('https://keto-diet.p.rapidapi.com/?search=$query');

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
    throw Exception('Failed to search meals from RapidAPI');
  }
}

class Category {
  final int id;
  final String category;
  final String thumbnail;

  Category({required this.id, required this.category, required this.thumbnail});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      category: json['category'],
      thumbnail: json['thumbnail'],
    );
  }
}

Future<List<Category>> getCategories() async {
  final response = await http.get(
    Uri.parse('https://keto-diet.p.rapidapi.com/categories/'),
    headers: {
      'x-rapidapi-host': 'keto-diet.p.rapidapi.com',
      'x-rapidapi-key': '98e3c41bdamsh6960eb2e07a8eabp1de9ecjsn02d167280bf6',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Category.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load categories');
  }
}

Future<List<Meal>> getMealsByCategory(String categoryId) async {
  final response = await http.get(
    Uri.parse('https://keto-diet.p.rapidapi.com/?category=$categoryId'),
    headers: {
      'x-rapidapi-host': 'keto-diet.p.rapidapi.com',
      'x-rapidapi-key': '98e3c41bdamsh6960eb2e07a8eabp1de9ecjsn02d167280bf6',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load meals for category');
  }
}
