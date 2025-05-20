import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/profile/change_password_service.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/theme/app_colors.dart';
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
  var emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;

  String? _passwordMatchError;
  String? _emptyFieldError;

  String? _validatePasswords() {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;

    if (oldPassword.isEmpty || newPassword.isEmpty) {
      return appLocalizations.pleaseFillOutBothFields;
    }
    setState(() {
      _passwordMatchError = null;
    });
    return null;
  }

  String? _validateEmptyFields() {
    if (_oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty) {
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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: AppColors.purple,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: Text(appLocalizations.resetPassword),
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
            TextFormField(
              controller: _oldPasswordController,
              obscureText: _obscureOldPassword,
              decoration: InputDecoration(
                hintText: "Old password",
                // hintText: appLocalizations.oldPass,
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
                errorText: _passwordMatchError ?? _emptyFieldError,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              decoration: InputDecoration(
                hintText: appLocalizations.newPass,
                prefixIcon: const ImageIcon(AssetImage(AppIcons.passwordIcon)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
                errorText: _passwordMatchError ?? _emptyFieldError,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () async {
                _validateEmptyFields();
                _validatePasswords();
                if (_emptyFieldError == null && _passwordMatchError == null) {
                  try {
                    String? message = await ChangePasswordService.resetPassword(
                      oldPassword: _oldPasswordController.text,
                      newPassword: _newPasswordController.text,
                    );
                    if (message != null) {
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
                        appLocalizations.resetPassword,
                      );
                    }
                  } catch (e) {
                    showMessage(
                      context,
                      'Error resetting password: $e',
                    );
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
