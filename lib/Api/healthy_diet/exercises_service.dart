import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/exercises.dart';
import 'package:http/http.dart' as http;

class ExerciseApiService {
  static String baseUrl = 'http://${MyApp.IP}/api/exercises';

  Future<List<Exercise>> fetchExercisesByBodyPart(String bodyPart) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      List filtered = data
          .where((e) =>
              e['bodyPart'].toString().toLowerCase() == bodyPart.toLowerCase())
          .toList();

      return filtered.map((e) => Exercise.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<List<Exercise>> getAllExercises() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Exercise.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<Exercise> getExerciseById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Exercise.fromJson(json.decode(response.body));
    } else {
      throw Exception('Exercise not found');
    }
  }

  Future<Exercise> getExerciseByStringId(String exId) async {
    final response = await http.get(Uri.parse('$baseUrl/by-string-id/$exId'));
    if (response.statusCode == 200) {
      return Exercise.fromJson(json.decode(response.body));
    } else {
      throw Exception('Exercise not found');
    }
  }

  Future<Exercise> createExercise(Exercise exercise) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(exercise.toJson()),
    );
    if (response.statusCode == 200) {
      return Exercise.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create exercise');
    }
  }

  Future<Exercise> updateExercise(int id, Exercise exercise) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(exercise.toJson()),
    );
    if (response.statusCode == 200) {
      return Exercise.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update exercise');
    }
  }

  Future<void> deleteExercise(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete exercise');
    }
  }
}
