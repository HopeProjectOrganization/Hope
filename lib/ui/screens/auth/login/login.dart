import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/auth/auth.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/auth/forgetpassword/forgetpassword.dart';
import 'package:hope/ui/screens/auth/login/login_with_google.dart';
import 'package:hope/ui/screens/auth/register/register.dart';
import 'package:hope/ui/screens/home/home.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:hope/ui/shared_widgets/custom_text_field.dart';
import 'package:hope/ui/shared_widgets/language_switch.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
import 'package:icons_plus/icons_plus.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/loginScreen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AppLocalizations appLocalizations;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final AuthApiService authService = AuthApiService();
  bool _obscurePassword = true;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      Image.asset(
                        AppAssets.login,
                        height: constraints.maxHeight * 0.25,
                      ),
                      const SizedBox(height: 32),
                      buildEmailTextField(),
                      const SizedBox(height: 16),
                      buildPasswordTextField(),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, ForgetpasswordScreen.routeName);
                          },
                          child: Text(appLocalizations.forgetPassword),
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildLoginButton(),
                      const SizedBox(height: 16),
                      buildSignUpRow(),
                      const SizedBox(height: 8),
                      buildORText(),
                      const SizedBox(height: 16),
                      buildGoogleSignInButton(),
                      const Spacer(),
                      const SizedBox(height: 16),
                      Center(child: LanguageSwitch()),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmailTextField() {
    return CustomTextField(
      controller: emailController,
      hint: appLocalizations.email,
      prefixIcon: const ImageIcon(AssetImage(AppIcons.emailIcon)),
      validator: (email) {
        if (email == null || email.isEmpty) {
          return appLocalizations.emailRequired;
        }
        final bool emailValid = RegExp(
          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$",
        ).hasMatch(email);
        if (!emailValid) {
          return appLocalizations.invalidEmail;
        }
        return null;
      },
    );
  }

  Widget buildPasswordTextField() {
    return TextFormField(
      controller: passwordController,
      style: Theme.of(context).textTheme.bodyLarge,
      cursorColor: Theme.of(context).primaryColor,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: appLocalizations.password,
        prefixIcon: const ImageIcon(AssetImage(AppIcons.passwordIcon)),
        suffixIcon: IconButton(
          icon:
              Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        errorStyle: const TextStyle(color: AppColors.red),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return appLocalizations.password;
        }
        return null;
      },
    );
  }

  Widget buildLoginButton() {
    return CustomButton(
      title: appLocalizations.login,
      onClick: () async {
        if (formKey.currentState!.validate()) {
          final success = await authService.loginAndRedirectUser(
            context: context,
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
          if (!success) {
            showMessage(context, appLocalizations.loginFailed,
                type: MessageType.error);
          }
        }
      },
    );
  }

  Widget buildSignUpRow() {
    return Row(
      children: [
        Expanded(
          child: Text(appLocalizations.dontHaveAccount,
              style: Theme.of(context).textTheme.bodyLarge),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, RegisterScreen.routeName);
          },
          child: Text(appLocalizations.createAccount),
        ),
      ],
    );
  }

  Widget buildORText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(appLocalizations.or,
                style: Theme.of(context).textTheme.labelMedium),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  Widget buildGoogleSignInButton() {
    return FilledButton(
      onPressed: () async {
        try {
          final provider = GoogleSignInProvider();
          final userCredential = await provider.signInWithGoogle();

          if (userCredential != null) {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          } else {
            showMessage(context, appLocalizations.loginFailed,
                type: MessageType.error);
          }
        } catch (e) {
          showMessage(context, '${appLocalizations.error}: $e',
              type: MessageType.error);
        }
      },
      style: FilledButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Brand(Brands.google),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              textAlign: TextAlign.center,
              appLocalizations.googleLogin,
              softWrap: true,
              maxLines: null, // أو حط رقم لو عايز تحدد أقصى عدد أسطر
            ),
          ),
        ],
      ),
    );
  }
}
