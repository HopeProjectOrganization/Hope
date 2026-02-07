import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/Admin/home/home.dart';
import 'package:hope/Api/profile/profile_service.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/main.dart';
import 'package:hope/model/register_dm.dart';
import 'package:hope/ui/screens/home/home.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthApiService {
  final String baseUrl = 'http://${MyApp.IP}/api/v1/auth';

  /// ==================== Register ====================
  Future<http.Response> register({
    required RegisterRequestModel request,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );
    return response;
  }

  /// ==================== Login ====================
  Future<http.Response> authenticate({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authenticate'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    return response;
  }

  /// ==================== LoginUserOrAdmin ====================

  Future<bool> loginAndRedirectUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final localizations = AppLocalizations.of(context)!;

    try {
      showLoading(context);

      final response = await authenticate(email: email, password: password);

      hideLoading(context);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final token = data['token'];

        if (token != null) {
          await storeToken(token);

          final profileService = GetUserProfile();
          final userData = await profileService.fetchUserProfile(token);

          if (userData != null) {
            final role = userData.role.toUpperCase();

            if (role == 'ADMIN') {
              Navigator.pushReplacementNamed(
                  context, AdminHomeScreen.routeName);
            } else if (role == 'USER') {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            } else {
              showMessage(context, "Unknown role: {role}");
            }

            return true;
          } else {
            showMessage(context, localizations.failedToLoadUserData);
            return false;
          }
        } else {
          showMessage(context, localizations.tokenNotFound);
          return false;
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        showMessage(
          context,
          localizations.invalidEmailOrPassword,
          title: localizations.loginFailed,
          type: MessageType.error,
        );
        return false;
      } else {
        showMessage(context, localizations.loginErrorTryAgain);
        return false;
      }
    } catch (e) {
      hideLoading(context);
      showMessage(context, '${localizations.errorOccurred}: $e');
      return false;
    }
  }

  /// ==================== Forgot Password ====================
  Future<http.Response> forgotPassword({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );
    return response;
  }

  /// ==================== Reset Password ====================
  Future<http.Response> resetPassword({
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "newPassword": newPassword,
        "newPasswordConfirm": newPasswordConfirm,
      }),
    );
    return response;
  }

  /// ==================== Verify Code ====================
  Future<http.Response> verifyCode({
    required String code,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Verify'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"code": code}),
    );
    return response;
  }

  /// ==================== Resend Code ====================
  Future<http.Response> resendCode() async {
    final response = await http.post(
      Uri.parse('$baseUrl/Resend'),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  /// ==================== Token Handling ====================

  // تخزين التوكن
  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    print('Token stored: $token');
  }

  // جلب التوكن
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // حذف التوكن (تسجيل الخروج)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.reload();
  }

  // فحص هل المستخدم مسجل دخول
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') != null;
  }
}
