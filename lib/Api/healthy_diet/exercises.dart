import 'dart:convert';

import 'package:hope/model/exercises.dart';
import 'package:http/http.dart' as http;

class ExerciseService {
  static Future<List<Exercise>> fetchByBodyPart(String bodyPart) async {
    final String url =
        'https://exercisedb.p.rapidapi.com/exercises/bodyPart/$bodyPart?limit=20';
    const Map<String, String> headers = {
      'x-rapidapi-key': 'cee3c198b5msh06fb61b0d1e747fp11e9cfjsn1b083226fe05',
      'x-rapidapi-host': 'exercisedb.p.rapidapi.com',
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Exercise.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}
