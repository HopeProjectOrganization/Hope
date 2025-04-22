import 'dart:convert';

import 'package:hope/model/get_profile.dart';
import 'package:http/http.dart' as http;

class GetUserProfile {
  Future<Data?> fetchUserProfile(String token) async {
    final url = Uri.parse('http://192.168.1.58:8081/api/profile');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Raw response: ${response.body}");
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return Data.fromJson(jsonMap);
      } else {
        print("Failed to fetch profile. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching profile: $e");
      return null;
    }
  }
}
