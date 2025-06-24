import 'package:flutter/material.dart';
import 'package:hope/main.dart';
import 'package:hope/ui/screens/auth/login/login.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeleteService {
  static String baseUrl = "https://${MyApp.IP}/api/profile";

  Future<void> deleteProfile(BuildContext context) async {
    try {
      showLoading(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('auth_token');

      hideLoading(context);
      if (authToken == null) {
        return;
      }

      final response = await http.delete(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer ${authToken.trim()}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('auth_token');
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginScreen.routeName,
          (route) => false,
        );
      } else {
        showMessage(context, response.statusCode.toString(), title: "Error");
      }
    } catch (e) {
      hideLoading(context);
      showMessage(context, e.toString(), title: "Error");
    }
  }
}
