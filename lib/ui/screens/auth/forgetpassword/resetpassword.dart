import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/ui/screens/auth/forgetpassword/forgetpassword.dart';
import 'package:hope/ui/screens/auth/login/login.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
import 'package:http/http.dart' as http;

class ResetpasswordScreen extends StatefulWidget {
  static const String routeName = "/resetpasswordScreen";

  const ResetpasswordScreen({super.key});

  @override
  ResetpasswordScreenState createState() => ResetpasswordScreenState();
}

class ResetpasswordScreenState extends State<ResetpasswordScreen> {
  late AppLocalizations appLocalizations;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  String? _passwordMatchError;
  String? _emptyFieldError;

  Future<void> resetPassword(String newPassword, String confirmPassword) async {
    final url =
        Uri.parse('http://192.168.1.109:9090/api/v1/auth/reset-password');
    final body = jsonEncode({
      'newPassword': newPassword,
      'newPasswordConfirm': confirmPassword,
    });
    try {
      showLoading(context);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      hideLoading(context);
      if (response.statusCode == 200) {
        print('Password reset successfully');
        showMessage(
          context,
          "Password reset successfully",
          title: "Reset",
          posButtonTitle: "Done",
          posButtonClick: () {
            Navigator.pushNamed(context, LoginScreen.routeName);
          },
        );
      } else {
        showMessage(
          context,
          "${response.statusCode}",
          title: "Error during reset password!",
          posButtonTitle: "Try again",
          posButtonClick: () {
            Navigator.pushNamed(context, ForgetpasswordScreen.routeName);
          },
        );
        print('Failed to reset password: ${response.body}');
      }
    } catch (e) {
      showMessage(
        context,
        "${e.toString()}",
        title: "Error during reset password! ",
        posButtonTitle: "Try again",
        posButtonClick: () {
          Navigator.pushNamed(context, ForgetpasswordScreen.routeName);
        },
      );
      print('Error: $e');
    }
  }

  String? _validatePasswords() {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      return appLocalizations.pleaseFillOutBothFields;
    } else if (newPassword != confirmPassword) {
      setState(() {
        _passwordMatchError = appLocalizations.passwordsDoNotMatch;
      });
      return null;
    }
    setState(() {
      _passwordMatchError = null;
    });
    return null;
  }

  String? _validateEmptyFields() {
    if (_newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _emptyFieldError = appLocalizations.pleaseFillOutBothFields;
      });
      return null;
    }
    setState(() {
      _emptyFieldError = null;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.resetPassword),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Image.asset(
              AppAssets.resetPassword,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            Text(
              appLocalizations.enterNewPass,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            // New Password Field
            TextFormField(
              controller: _newPasswordController,
              style: Theme.of(context).textTheme.bodyLarge,
              cursorColor: Theme.of(context).primaryColor,
              obscureText: _obscureNewPassword,
              decoration: InputDecoration(
                hintText: appLocalizations.newPass,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                errorText: _emptyFieldError,
                errorStyle: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 16),
            // Confirm Password Field
            TextFormField(
              controller: _confirmPasswordController,
              style: Theme.of(context).textTheme.bodyLarge,
              cursorColor: Theme.of(context).primaryColor,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                hintText: appLocalizations.confirmNewPass,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        _passwordMatchError != null || _emptyFieldError != null
                            ? Colors.red
                            : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        _passwordMatchError != null || _emptyFieldError != null
                            ? Colors.red
                            : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                errorText: _passwordMatchError ?? _emptyFieldError,
                errorStyle: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 32),
            // Reset Button
            FilledButton(
              onPressed: () async {
                _validateEmptyFields();
                _validatePasswords();
                if (_emptyFieldError == null && _passwordMatchError == null) {
                  // showLoading(context);
                  try {
                    await resetPassword(_newPasswordController.text,
                        _confirmPasswordController.text);
                    showMessage(
                      context,
                      appLocalizations.yourPasswordHasBeenReset,
                      posButtonTitle: appLocalizations.done,
                    );
                  } catch (e) {
                    showMessage(
                      context,
                      'Error resetting password: $e',
                    );
                  } finally {
                    Navigator.of(context).pop();
                  }
                }
              },
              child: Text(appLocalizations.reset),
            ),
          ],
        ),
      ),
    );
  }
}
