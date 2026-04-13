import 'package:flutter/material.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/Api/auth/auth.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/auth/forgetpassword/verify/verification.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';

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

  /// نستخدم الـ AuthApiService اللي أصلاً معمول وجاهز
  Future<void> forgetPassword(String input) async {
    final service = AuthApiService();
    try {
      showLoading(context);
      final response = await service.forgotPassword(email: input);
      hideLoading(context);

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, VerficationScreen.routeName);
      } else {
        showMessage(
          context,
          "${response.statusCode}",
          title: "Error during reset password!",
          posButtonTitle: "Try again",
          posButtonClick: () {
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      hideLoading(context);
      showMessage(
        context,
        "Error: $e",
        title: "Error during reset password!",
        posButtonTitle: "Try again",
        posButtonClick: () {
          Navigator.pop(context);
        },
      );
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
