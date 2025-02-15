import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/ui/screens/auth/forgetpassword/resetpassword.dart';
import 'package:hope/ui/screens/auth/register/register.dart';

class VerficationScreen extends StatefulWidget {
  static const String routeName = "/verficationScreen";

  const VerficationScreen({super.key});

  @override
  State<VerficationScreen> createState() => _VerficationScreenState();
}

class _VerficationScreenState extends State<VerficationScreen> {
  late AppLocalizations appLocalizations;

  // Text controllers and focus nodes for each TextField
  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

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
                      onFieldSubmitted: (value) {
                        // Automatically move focus to the next field if not the last
                        if (index < 3 && value.isNotEmpty) {
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index + 1]);
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
                  appLocalizations.receiveCode,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterScreen.routeName);
                  },
                  child: Text(appLocalizations.sendAgain),
                )
              ],
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                Navigator.pushNamed(context, ResetpasswordScreen.routeName);
              },
              child: Text(appLocalizations.verify),
            ),
          ],
        ),
      ),
    );
  }
}

// CircleInput widget with dynamic color change and focus auto-move
class CircleInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onFieldSubmitted;

  const CircleInput({
    required this.controller,
    required this.focusNode,
    required this.onFieldSubmitted,
    super.key,
  });

  @override
  CircleInputState createState() => CircleInputState();
}

class CircleInputState extends State<CircleInput> {
  bool isFilled = false;

  @override
  void initState() {
    super.initState();
    // Listen for changes in the text field to update the UI accordingly
    widget.controller.addListener(() {
      setState(() {
        isFilled = widget.controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isFilled ? const Color(0xff8E56FF) : const Color(0xffC9C9C9),
        // Color changes based on input
        shape: BoxShape.circle,
      ),
      child: Center(
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(fontSize: 24, color: Colors.white),
          decoration: const InputDecoration(
            isCollapsed: true,
            contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            counterText: '',
          ),
          onChanged: widget.onFieldSubmitted,
        ),
      ),
    );
  }
}
