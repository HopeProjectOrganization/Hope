import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
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
  var emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  String? _passwordMatchError;
  String? _emptyFieldError;

  Future<void> resetPassword(String email) async {
    final url = Uri.parse('http://localhost:8080/api/v1/auth/reset-password');
    final body = jsonEncode({
      'email': email,
    });
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        print('Password reset email sent successfully');
      } else {
        print('Failed to send reset password request: ${response.body}');
      }
    } catch (e) {
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
              // Toggle password visibility
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
                // Error message if empty
                errorStyle: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 16),
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
            // FilledButton(
            //   onPressed: () {
            //     _validateEmptyFields(); // Validate if fields are filled
            //     _validatePasswords(); // Validate password match
            //     if (_emptyFieldError == null && _passwordMatchError == null) {
            //       showLoading(context);
            //       showMessage(context,
            //       appLocalizations.yourPasswordHasBeenReset,
            //       posButtonTitle: appLocalizations.done
            //       );
            //     }
            //   },
            //   child: Text(appLocalizations.reset),
            // ),
            FilledButton(
              onPressed: () async {
                _validateEmptyFields();
                _validatePasswords();
                if (_emptyFieldError == null && _passwordMatchError == null) {
                  showLoading(context);
                  try {
                    await resetPassword(emailController.text);
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
            )
          ],
        ),
      ),
    );
  }
}

