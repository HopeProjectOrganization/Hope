import 'dart:convert';

import 'package:hope/model/get_profile.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  Future<GetUserProfileData?> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse("http://192.168.1.58:8081/api/profile"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print("Raw response: ${response.body}");
      final json = jsonDecode(response.body);
      return GetUserProfileData.fromJson(json);
    } else {
      print("Failed to fetch profile. Status code: ${response.statusCode}");
      return null;
    }
  }
}
