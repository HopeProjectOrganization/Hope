// import 'package:flutter/material.dart';
// import 'package:hope/ui/screens/auth/login/login.dart';
// import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class LogoutService {
//   Future<void> logoutUser(BuildContext context) async {
//     try {
//       showLoading(context);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//
//       String? userId = prefs.getString('user_id');
//       await prefs.clear();
//       await prefs.setString('user_id', userId ?? "");
//
//       await prefs.remove('auth_token');
//       await prefs.reload();
//
//       hideLoading(context);
//       Navigator.pushNamedAndRemoveUntil(
//         context,
//         LoginScreen.routeName,
//         (route) => false,
//       );
//     } catch (e) {
//       hideLoading(context);
//       showMessage(context, e.toString());
//     }
//   }
//
//   Future<bool> isLoggedIn() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool loggedIn = prefs.getString('auth_token') != null;
//     return loggedIn;
//   }
// }
