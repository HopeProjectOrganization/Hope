import 'dart:convert';

import 'package:hope/model/places_dm.dart';
import 'package:http/http.dart' as http;

Future<PlaceModel?> fetchPlaceById(String id) async {
  final url = Uri.parse("http://192.168.78.153:8080/Places/id/$id");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    print("Response: ${response.body}");
    final json = jsonDecode(response.body);
    final place = PlaceModel.fromJson(json);
    print("Fetched place: $place"); // لازم يطبع مش null
    return place;
  } else {
    throw Exception('Failed to load place');
  }
}