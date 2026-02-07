import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/places_dm.dart';
import 'package:http/http.dart' as http;

class PlacesApiService {
  final String baseUrl = 'http://${MyApp.IP}/Places';

  // جلب مكان معين بالـ ID
  Future<PlaceModel> fetchPlaceById(int id) async {
    final url = Uri.parse('$baseUrl/id/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return PlaceModel.fromJson(jsonBody);
    } else {
      throw Exception('فشل تحميل المكان');
    }
  }

  // جلب جميع الأماكن
  Future<List<PlaceModel>> fetchAllPlaces() async {
    final url = Uri.parse('$baseUrl/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((jsonItem) => PlaceModel.fromJson(jsonItem)).toList();
    } else {
      throw Exception('فشل تحميل كل الأماكن');
    }
  }

  // إضافة مكان جديد
  Future<PlaceModel> addPlace(PlaceModel place) async {
    final url = Uri.parse('$baseUrl/addPlace');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(place.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return PlaceModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('فشل إضافة المكان');
    }
  }

  // تحديث مكان
  Future<PlaceModel> updatePlace(int id, PlaceModel place) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(place.toJson()),
    );

    if (response.statusCode == 200) {
      return PlaceModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('فشل تعديل المكان');
    }
  }

  // حذف مكان
  Future<void> deletePlace(int id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('فشل حذف المكان');
    }
  }
}
