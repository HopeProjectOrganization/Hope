import 'dart:convert';

import 'package:hope/main.dart';
import 'package:hope/model/get_profile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetUserProfile {
  Future<Data?> fetchUserProfile(String token) async {
    final url = Uri.parse('https://${MyApp.IP}/api/profile');

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
        final profileData = Data.fromJson(jsonMap);

        // 🔐 حفظ userId في SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt("userId", profileData.id!);
        await prefs.setString("avatarId", profileData.avatarId ?? "5");

        print("✅ Saved userId: ${profileData.id}");
        print("✅ Saved avatarId: ${profileData.avatarId}");

        return profileData;
      } else {
        print("❌ Failed to fetch profile: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Error fetching profile: $e");
      return null;
    }
  }
}
