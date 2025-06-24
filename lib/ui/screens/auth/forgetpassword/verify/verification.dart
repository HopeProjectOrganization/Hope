import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/main.dart';
import 'package:hope/ui/screens/auth/forgetpassword/resetpassword.dart';
import 'package:hope/ui/screens/auth/forgetpassword/verify/circle_input.dart';
import 'package:http/http.dart' as http;

class VerficationScreen extends StatefulWidget {
  static const String routeName = "/verficationScreen";

  const VerficationScreen({super.key});

  @override
  State<VerficationScreen> createState() => _VerficationScreenState();
}

class _VerficationScreenState extends State<VerficationScreen> {
  late AppLocalizations appLocalizations;

  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  Timer? _timer;
  int _remainingTime = 60;
  bool _isCodeValid = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _isCodeValid = false; // Code becomes invalid
        });
        _timer?.cancel();
      }
    });
  }

  Future<void> resendCode() async {
    if (!_isCodeValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Code expired. Please request a new code.")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://${MyApp.IP}/api/v1/auth/Resend'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Code sent again successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to resend code")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error")),
      );
    }
  }

  Future<void> verifyCode() async {
    if (!_isCodeValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("The code has expired. Please request a new one.")),
      );
      return;
    }

    String code = controllers.map((controller) => controller.text).join();
    if (code.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid code")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://${MyApp.IP}/api/v1/auth/Verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, ResetpasswordScreen.routeName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verification failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network error")),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer when leaving the screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.verification),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Image.asset(
              AppAssets.verification,
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.35,
            ),
            Text(
              appLocalizations.enterEmailOrPhone,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Row(
                  children: [
                    CircleInput(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index - 1]);
                        }
                      },
                      onDeleted: () {
                        if (controllers[index].text.isEmpty && index > 0) {
                          controllers[index - 1].clear();
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index - 1]);
                        }
                      },
                    ),
                    const SizedBox(width: 20),
                  ],
                );
              }),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isCodeValid
                      ? "Time left: $_remainingTime seconds"
                      : "Code expired! Please resend.",
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    appLocalizations.receiveCode,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      resendCode(); // Call the resend code API when pressed
                    },
                    child: Text(appLocalizations.sendAgain),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                verifyCode();
              },
              child: Text(appLocalizations.verify),
            ),
          ],
        ),
      ),
    );
  }
}
