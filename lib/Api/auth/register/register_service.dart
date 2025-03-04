import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/ui/screens/auth/login/login.dart';
import 'package:hope/ui/screens/auth/register/register.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RegisterService {
  static const String _baseUrl = 'http://192.168.1.109:9090/api/v1/auth';

  Future<void> registerUser({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
    required String phone,
    required bool? isMale,
    required bool smoker,
    required bool haveCancer,
    required String cancerType,
    required bool haveAFamilyCancer,
    required String familyType,
    required DateTime dateOfBirth,
  }) async {
    final String apiUrl = '$_baseUrl/register';

    final Map<String, dynamic> userData = {
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
      'isMale': isMale,
      'smoker': smoker,
      'haveCancer': haveCancer,
      'type': cancerType,
      'haveAFamilyCancer': haveAFamilyCancer,
      'familyType': familyType,
      'dateOfBirth': DateFormat('yyyy-MM-dd').format(dateOfBirth),
    };

    try {
      showLoading(context);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      hideLoading(context);

      if (response.statusCode == 200) {
        showMessage(
          context,
          " You have been successfully registered! ",
          title: "Success",
          posButtonTitle: "Done",
          posButtonClick: () {
            Navigator.pushNamed(context, LoginScreen.routeName);
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم التسجيل بنجاح!')),
        );
      } else {
        showMessage(
          context,
          "${response.statusCode}",
          title: "Error during registration! : ",
          posButtonTitle: "Try again",
          posButtonClick: () {
            Navigator.pushNamed(context, RegisterScreen.routeName);
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ في التسجيل!')),
        );
      }
    } catch (e) {
      print('حدث خطأ: $e');
      showMessage(
        context,
        "${e.toString()}",
        title: "Error during registration! : ",
        posButtonTitle: "Try again",
        posButtonClick: () {
          Navigator.pushNamed(context, RegisterScreen.routeName);
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في الاتصال بالخادم!')),
      );
    }
  }
}
