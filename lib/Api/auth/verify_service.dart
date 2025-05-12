import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/ui/screens/auth/login/login.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
import 'package:http/http.dart' as http;

class VerifyService {
  final String baseUrl = 'http://192.168.1.56:8081/api/v1/auth';

  Future<void> resendCode(BuildContext context, bool isCodeValid) async {
    if (!isCodeValid) {
      _showSnackBar(context, "Code expired. Please request a new code.");
      return;
    }

    try {
      showLoading(context);
      final response = await http.post(
        Uri.parse('$baseUrl/Resend'),
        headers: {'Content-Type': 'application/json'},
      );

      hideLoading(context);

      if (response.statusCode == 200) {
        showMessage(
          context,
          "Code sent again successfully",
          title: "Verification",
        );
        _showSnackBar(context, "Code sent again successfully");
      } else {
        showMessage(
          context,
          "Failed to resend code",
          title: "Verification",
          posButtonTitle: "Done",
          posButtonClick: () {
            Navigator.pop;
          },
        );
        _showSnackBar(context, "Failed to resend code");
      }
    } catch (e) {
      showMessage(
        context,
        "${e.toString()}",
        title: "Error! : ",
        posButtonTitle: "Try again",
        posButtonClick: () {
          Navigator.pop;
        },
      );
      _showSnackBar(context, "Network error");
    }
  }

  Future<void> verifyCode(BuildContext context,
      List<TextEditingController> controllers, bool isCodeValid) async {
    if (!isCodeValid) {
      showMessage(
        context,
        "The code has expired.",
        title: "Verification",
        posButtonTitle: "Try again",
        posButtonClick: () {
          Navigator.pop;
        },
      );
      //_showSnackBar(context, "The code has expired. Please request a new one.");
      return;
    }

    String code = controllers.map((controller) => controller.text).join();
    if (code.length != 4) {
      showMessage(
        context,
        "Invalid code",
        title: "Verification",
        posButtonTitle: "Try again",
        posButtonClick: () {
          Navigator.pop;
        },
      );
      _showSnackBar(context, "Invalid code");
      return;
    }

    try {
      showLoading(context);
      final response = await http.post(
        Uri.parse('$baseUrl/Verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      hideLoading(context);
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, LoginScreen.routeName);
      } else {
        _showSnackBar(context, "Verification failed");
      }
    } catch (e) {
      _showSnackBar(context, "Network error");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
