import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/get_profile.dart';
import 'package:http/http.dart' as http;

class GetUserProfile {
  Future<Data?> fetchUserProfile(String token) async {
    final url = Uri.parse('http://${MyApp.IP}/api/profile');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return Data.fromJson(jsonMap);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
