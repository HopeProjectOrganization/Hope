import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/theme/app_colors.dart';
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
  final TextEditingController PasswordController = TextEditingController();
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
    String newPassword = PasswordController.text;
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
    if (PasswordController.text.isEmpty ||
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
            buildPasswordTextField(context),
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
                    await resetPassword(PasswordController.text,
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

  bool _obscurePassword = true;
  List<String> passwordHints = [];
  int passwordStrength = 0;

  List<String> getPasswordErrors(String password) {
    List<String> errors = [];
    passwordStrength = 0;

    if (password.length >= 8) {
      errors.add("✅ At least 8 characters");
      passwordStrength++;
    } else {
      errors.add("❌ At least 8 characters");
    }

    if (RegExp(r'[A-Z]').hasMatch(password)) {
      errors.add("✅ Has uppercase letter");
      passwordStrength++;
    } else {
      errors.add("❌ At least one uppercase letter");
    }

    if (RegExp(r'[a-z]').hasMatch(password)) {
      errors.add("✅ Has lowercase letter");
      passwordStrength++;
    } else {
      errors.add("❌ At least one lowercase letter");
    }

    if (RegExp(r'\d').hasMatch(password)) {
      errors.add("✅ Has number");
      passwordStrength++;
    } else {
      errors.add("❌ At least one number");
    }

    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      errors.add("✅ Has special character");
      passwordStrength++;
    } else {
      errors.add("❌ At least one special character (!@#\$&*~)");
    }

    return errors;
  }

  Widget buildPasswordTextField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: PasswordController,
          obscureText: _obscurePassword,
          onChanged: (value) {
            setState(() {
              passwordHints = getPasswordErrors(value);
            });
          },
          decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (PasswordController.text.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: passwordStrength / 5,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                passwordStrength <= 2
                    ? AppColors.red
                    : passwordStrength == 3 || passwordStrength == 4
                        ? Colors.orange
                        : Colors.green,
              ),
            ),
          ),
        if (PasswordController.text.isNotEmpty) const SizedBox(height: 12),
        if (PasswordController.text.isNotEmpty)
          if (passwordHints.isNotEmpty)
            Card(
              elevation: 2,
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: passwordHints.map((hint) {
                    final isValid = hint.startsWith("✅");
                    return Row(
                      children: [
                        Icon(
                          isValid ? Icons.check_circle : Icons.cancel,
                          size: 18,
                          color: isValid ? Colors.green : AppColors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          hint.replaceFirst("✅ ", "").replaceFirst("❌ ", ""),
                          style: TextStyle(
                            color: isValid ? Colors.green : AppColors.red,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
      ],
    );
  }
}
