import 'dart:convert';
import 'package:hope/main.dart';
import 'package:flutter/material.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
import 'package:http/http.dart' as http;

class AvatarService {
  final String? token;

  AvatarService({required this.token});

  Future<void> updateAvatar({
    required BuildContext context,
    required String name,
    required String email,
    required String avatarId,
    required String phone,
  }) async {
    final String url = "http://${MyApp.IP}/api/profile";
    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    final Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "imageId": avatarId,
      "phone": phone
    };

    try {
      showLoading(context);
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      hideLoading(context);

      if (response.statusCode == 200) {
        showMessage(context, "Profile updated successfully",
            posButtonTitle: "Done");
      } else {
        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        showMessage(context, "Failed to update profile",
            posButtonTitle: "Try again");
      }
    } catch (e) {
      showMessage(context, "Error $e", title: "Error");
    }
  }
}
