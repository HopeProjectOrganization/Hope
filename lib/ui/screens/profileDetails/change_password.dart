import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/profile/change_password_service.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/ui/shared_widgets/password.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = "/changepasswordScreen";

  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
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
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            appLocalizations.changePassword,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
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
            const SizedBox(height: 16),
            // Old Password Field
            TextFormField(
              controller: _oldPasswordController,
              obscureText: _obscureOldPassword,
              decoration: InputDecoration(
                hintText: appLocalizations.oldPassword,
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
                    context,
                    appLocalizations.pleaseFillOutAllFields,
                    posButtonTitle: appLocalizations.ok,
                  );
                  return;
                }

                if (_newPasswordController.text !=
                    _confirmPasswordController.text) {
                  showMessage(
                    context,
                    appLocalizations.passwordsDoNotMatch,
                    posButtonTitle: appLocalizations.ok,
                  );
                  return;
                }

                try {
                  showLoading(context);
                  String? message = await ChangePasswordService.resetPassword(
                    oldPassword: _oldPasswordController.text,
                    newPassword: _newPasswordController.text,
                  );
                  hideLoading(context);

                  if (message != null) {
                    showMessage(
                      context,
                      appLocalizations.yourPasswordHasBeenReset,
                      posButtonTitle: appLocalizations.done,
                      posButtonClick: () => Navigator.of(context).pop(),
                    );
                  } else {
                    showMessage(
                      context,
                      appLocalizations.resetPassword,
                      posButtonTitle: appLocalizations.ok,
                    );
                  }
                } catch (e) {
                  hideLoading(context);
                  showMessage(
                    context,
                    appLocalizations.errorResettingPassword,
                    posButtonTitle: appLocalizations.ok,
                  );
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
