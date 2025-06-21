import 'dart:convert';

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

  final AuthApiService authService =
      AuthApiService(); // إنشاء كائن من AuthService

  bool _obscurePassword = true;
  String? _emptyFieldError;

  String? emailError;
  String? passwordError;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Image.asset(
                AppAssets.login,
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              buildEmailTextField(context),
              const SizedBox(height: 16),
              buildPasswordTextField(context),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, ForgetpasswordScreen.routeName);
                    },
                    child: Text(appLocalizations.forgetPassword),
                  )
                ],
              ),
              const SizedBox(height: 16),
              buildLoginButton(context),
              const SizedBox(height: 16),
              buildSignUpRow(context),
              const SizedBox(height: 8),
              buildORText(context),
              const SizedBox(height: 16),
              buildGoogleSignInButton(context),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LanguageSwitch(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPasswordTextField(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      style: Theme.of(context).textTheme.bodyLarge,
      cursorColor: Theme.of(context).primaryColor,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: appLocalizations.password,
        prefixIcon: const ImageIcon(AssetImage(AppIcons.passwordIcon)),
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
        errorText: passwordError,
        errorStyle: const TextStyle(color: AppColors.red),
      ),
    );
  }

  Widget buildEmailTextField(BuildContext context) {
    return CustomTextField(
      controller: emailController,
      hint: appLocalizations.email,
      prefixIcon: const ImageIcon(AssetImage(AppIcons.emailIcon)),
      error: emailError,
      validator: (email) {
        if (email == null || email.isEmpty) {
          return "Please enter email";
        }
        final bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email);
        if (!emailValid) {
          return "The email address is badly formatted";
        }
        return null;
      },
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return CustomButton(
      onClick: () async {
        if (formKey.currentState!.validate()) {
          try {
            final response = await authService.authenticate(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

            if (response.statusCode == 200) {
              final responseData = jsonDecode(response.body);
              final token = responseData['token'];

              // خزن التوكن في SharedPreferences
              await authService.storeToken(token);

              // ادخله على الصفحة الرئيسية
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            } else if (response.statusCode == 401) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invalid credentials')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Login failed: ${response.body}')),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('An error occurred: $e')),
            );
          }
        }
      },
      title: appLocalizations.login,
    );
  }

  Widget buildSignUpRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            appLocalizations.dontHaveAccount,
          style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Expanded(
            flex: 1,
            child: TextButton(
              onPressed: () {
            Navigator.pushNamed(context, RegisterScreen.routeName);
          },
          child: Text(
            appLocalizations.createAccount,
          ),
            ))
      ],
    );
  }

  Padding buildORText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "or",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  FilledButton buildGoogleSignInButton(BuildContext context) {
    return FilledButton(
      onPressed: () async {
        final provider = GoogleSignInProvider();
        try {
          final userCredential = await provider.signInWithGoogle();

          if (userCredential != null) {
            print("Logged in as ${userCredential.user?.displayName}");
            // هنا مثلاً اعمل تنقل أو حدث ال state لتوجيه المستخدم للشاشة الرئيسية
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          } else {
            // المستخدم ألغى تسجيل الدخول أو حدث خطأ
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Google sign-in was cancelled or failed.')),
            );
          }
        } catch (e) {
          // خطأ عام غير متوقع
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error during Google sign-in: $e')),
          );
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
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Brand(Brands.google),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: Text(
                appLocalizations.googleLogin,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
