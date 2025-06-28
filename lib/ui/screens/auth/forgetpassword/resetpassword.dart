import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/auth/auth.dart';
import 'package:hope/core/assets/app_assets.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            appLocalizations.resetPassword,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
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
              AppAssets.resetPassword,
              height: MediaQuery.of(context).size.height * 0.35,
            ),
            const SizedBox(height: 16),
            Text(
              appLocalizations.enterNewPass,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            PasswordWithConfirmField(
              passwordController: _newPasswordController,
              confirmPasswordController: _confirmPasswordController,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _handleResetPassword,
              child: Text(appLocalizations.reset),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleResetPassword() async {
    if (_newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      showMessage(context, appLocalizations.pleaseFillOutBothFields,
          type: MessageType.warning);
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      showMessage(context, appLocalizations.passwordsDoNotMatch,
          type: MessageType.warning);
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
          appLocalizations.resetPasswordFailed,
          title: appLocalizations.errorOccurred,
          posButtonTitle: appLocalizations.tryAgain,
          posButtonClick: () {
            Navigator.pushNamed(context, ForgetpasswordScreen.routeName);
          },
        );
      }
    } catch (e) {
      hideLoading(context);
      showMessage(
        context,
        appLocalizations.resetPasswordError,
        title: appLocalizations.errorOccurred,
        posButtonTitle: appLocalizations.tryAgain,
        posButtonClick: () {
          Navigator.pushNamed(context, ForgetpasswordScreen.routeName);
        },
      );
    }
  }
}
