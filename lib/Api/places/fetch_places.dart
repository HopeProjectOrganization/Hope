import 'dart:convert';

import 'package:hope/model/places_dm.dart';
import 'package:http/http.dart' as http;

Future<List<PlaceModel>> fetchPlaces(int id) async {
  final url = Uri.parse("http://192.168.1.48:8081/Places/id/$id");
  final response = await http.get(url);

  print("Status code: ${response.statusCode}");
  print("Response body: ${response.body}");

  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(response.body);
    final place = PlaceModel.fromJson(jsonBody);
    return [place]; // عشان تتعاملي معاه في الواجهة كـ List
  } else {
    throw Exception('Failed to load place');
  }
}


