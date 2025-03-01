import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/auth/forgetpassword/verification.dart';
import 'package:http/http.dart' as http;

class ForgetpasswordScreen extends StatefulWidget {
  static const String routeName = "/forgetpasswordScreen";

  const ForgetpasswordScreen({super.key});

  @override
  ForgetpasswordScreenState createState() => ForgetpasswordScreenState();
}

class ForgetpasswordScreenState extends State<ForgetpasswordScreen> {
  late AppLocalizations appLocalizations;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _inputController = TextEditingController();

  Future<void> forgetPassword(String input) async {
    final url =
        Uri.parse('http://192.168.78.153:8080/api/v1/auth/forgot-password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': input,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, VerficationScreen.routeName);
      } else {
        print('Error');
        showMessage(context, "error");
      }
    } catch (e) {
      print('Error: $e');
      showMessage(context, 'Error: $e');
    }
  }

  String? _validateInput(String value) {
    final emailRegEx =
        RegExp(r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
    final phoneRegEx = RegExp(r"^\d{11}$");

    if (value.isEmpty) {
      return appLocalizations.enterEmailOrPhone;
    } else if (!emailRegEx.hasMatch(value) && !phoneRegEx.hasMatch(value)) {
      return appLocalizations.invalidEmailOrPhoneNumber;
    }
    return null;
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.forgetPassword),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Image.asset(
              AppAssets.forgetPassword,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            TextFormField(
              controller: _inputController,
              style: Theme.of(context).textTheme.bodyLarge,
              cursorColor: Theme.of(context).primaryColor,
              decoration: InputDecoration(
                hintText: appLocalizations.enterYourEmailOrMobile,
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.gray, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.gray, width: 1),
                ),
              ),
              validator: (value) {
                return _validateInput(value!);
              },
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  forgetPassword(_inputController.text);
                }
              },
              child: Text(appLocalizations.send),
            ),
          ],
        ),
      ),
    );
  }
}
