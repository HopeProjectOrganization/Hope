import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/auth/auth.dart'; // <-- استخدمنا AuthApiService هنا
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/ui/screens/auth/forgetpassword/forgetpassword.dart';
import 'package:hope/ui/shared_widgets/password.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';

class ResetpasswordScreen extends StatefulWidget {
  static const String routeName = "/resetpasswordScreen";

  const ResetpasswordScreen({super.key});

  @override
  ResetpasswordScreenState createState() => ResetpasswordScreenState();
}

class ResetpasswordScreenState extends State<ResetpasswordScreen> {
  late AppLocalizations appLocalizations;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureOldPassword = true;

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

            TextFormField(
              controller: _oldPasswordController,
              obscureText: _obscureOldPassword,
              decoration: InputDecoration(
                hintText: "Old password",
                prefixIcon: const ImageIcon(AssetImage(AppIcons.passwordIcon)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureOldPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureOldPassword = !_obscureOldPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // New Password + Confirm
            PasswordWithConfirmField(
              passwordController: _newPasswordController,
              confirmPasswordController: _confirmPasswordController,
            ),

            const SizedBox(height: 32),
            FilledButton(
              onPressed: () async {
                if (_oldPasswordController.text.isEmpty ||
                    _newPasswordController.text.isEmpty ||
                    _confirmPasswordController.text.isEmpty) {
                  showMessage(
                      context, appLocalizations.pleaseFillOutBothFields);
                  return;
                }

                if (_newPasswordController.text !=
                    _confirmPasswordController.text) {
                  showMessage(context, appLocalizations.passwordsDoNotMatch);
                  return;
                }

                try {
                  showLoading(context);

                  final response = await AuthApiService().resetPassword(
                    newPassword: _newPasswordController.text,
                    newPasswordConfirm: _confirmPasswordController.text,
                  );

                  hideLoading(context);

                  if (response.statusCode == 200) {
                    showMessage(
                      context,
                      appLocalizations.yourPasswordHasBeenReset,
                      posButtonTitle: appLocalizations.done,
                      posButtonClick: () {
                        Navigator.of(context).pop();
                      },
                    );
                  } else {
                    showMessage(
                      context,
                      "${response.statusCode}",
                      title: "Error during reset password!",
                      posButtonTitle: "Try again",
                      posButtonClick: () {
                        Navigator.pushNamed(
                            context, ForgetpasswordScreen.routeName);
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
                      Navigator.pushNamed(
                          context, ForgetpasswordScreen.routeName);
                    },
                  );
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
