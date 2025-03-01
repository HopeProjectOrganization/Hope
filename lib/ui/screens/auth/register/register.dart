import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/auth/login/login.dart';
import 'package:hope/ui/shared_widgets/custom_check_field.dart';
import 'package:hope/ui/shared_widgets/custom_drop_down.dart';
import 'package:hope/ui/shared_widgets/custom_gender.dart';
import 'package:hope/ui/shared_widgets/custom_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  DateTime selectedDate = DateTime.now();
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var repasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  String? _passwordMatchError;
  String? _emptyFieldError;

  bool? isMale;
  bool smoke = false;
  bool haveCancer = false;
  bool familyCancer = false;

  String cancerType = 'None';
  String familyCancerType = 'None';

  Future<void> registerUser() async {
    const String apiUrl = 'http://192.168.1.24:9090/api/v1/auth/register';
    DateTime formatDay =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final Map<String, dynamic> userData = {
      'username': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'phone': phoneController.text,
      'isMale': isMale,
      'smoker': smoke,
      'haveCancer': haveCancer,
      'type': cancerType,
      'haveAFamilyCancer': familyCancer,
      'familyType': familyCancerType,
      'dateOfBirth': "${DateFormat('yyyy-MM-dd').format(selectedDate)}",
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(userData),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم التسجيل بنجاح!')),
        );
        Navigator.pushNamed(context, LoginScreen.routeName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ في التسجيل!')),
        );
      }
    } catch (e) {
      print('حدث خطأ: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في الاتصال بالخادم!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.register),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Image.asset(
              AppAssets.register,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            CustomTextField(
                controller: usernameController,
                hint: appLocalizations.username,
                prefixIcon: const ImageIcon(AssetImage(AppIcons.userIcon))),
            const SizedBox(height: 16),
            CustomTextField(
              controller: emailController,
              hint: appLocalizations.email,
              prefixIcon: const ImageIcon(AssetImage(AppIcons.emailIcon)),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: phoneController,
              hint: appLocalizations.phone,
              prefixIcon: const ImageIcon(AssetImage(AppIcons.phoneIcon)),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(1900), // Adjust as needed
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: themeProvider.isDark()
                        ? AppColors.purple
                        : AppColors.gray,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    ImageIcon(
                      const AssetImage(AppIcons.calenderIcon),
                      color: themeProvider.isDark()
                          ? AppColors.white
                          : AppColors.gray,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      DateFormat('yyyy-MM-dd').format(selectedDate),
                      style: Theme.of(context).primaryTextTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            passwordTextField(context),
            const SizedBox(height: 16),
            confirmPasswordTextField(context),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: CustomGender(
                    isSelected: isMale == true,
                    labelText: appLocalizations.male,
                    onChanged: (value) {
                      setState(() {
                        isMale = true;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: CustomGender(
                    isSelected: isMale == false,
                    labelText: appLocalizations.female,
                    onChanged: (value) {
                      setState(() {
                        isMale = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomCheckField(
                width: 300,
                isChecked: smoke,
                labelText: appLocalizations.smoking),
            const SizedBox(height: 16),
            CustomCheckField(
                width: 300,
                isChecked: haveCancer,
                labelText: appLocalizations.hadCancer,
                onChanged: (value) {
                  setState(() {
                    haveCancer = value;
                  });
                }),
            if (haveCancer) const SizedBox(height: 16),
            if (haveCancer) CustomDropDown(),
            const SizedBox(height: 16),
            CustomCheckField(
                width: 300,
                isChecked: familyCancer,
                labelText: appLocalizations.familyCancer,
                onChanged: (value) {
                  setState(() {
                    familyCancer = value;
                  });
                }),
            if (familyCancer) const SizedBox(height: 16),
            if (familyCancer) CustomDropDown(),
            const SizedBox(height: 32),
            buildRegisterButton(context),
            buildSignInTextRow(context),
          ],
        ),
      ),
    );
  }

  Widget passwordTextField(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      style: Theme.of(context).textTheme.bodyLarge,
      cursorColor: Theme.of(context).primaryColor,
      obscureText: _obscureNewPassword,
      decoration: InputDecoration(
        hintText: appLocalizations.password,
        prefixIcon: const ImageIcon(AssetImage(AppIcons.passwordIcon)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureNewPassword = !_obscureNewPassword;
            });
          },
        ),
        errorText: _emptyFieldError,
      ),
    );
  }

  Widget confirmPasswordTextField(BuildContext context) {
    return TextFormField(
      controller: repasswordController,
      style: Theme.of(context).textTheme.bodyLarge,
      cursorColor: Theme.of(context).primaryColor,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        hintText: appLocalizations.confirmNewPass,
        prefixIcon: const ImageIcon(AssetImage(AppIcons.passwordIcon)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        errorText: _passwordMatchError ?? _emptyFieldError,
      ),
    );
  }

  FilledButton buildRegisterButton(BuildContext context) => FilledButton(
      onPressed: () {
        registerUser();
      },
      child: Text(appLocalizations.createAccount));

  Row buildSignInTextRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          appLocalizations.alreadyHaveAccount,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, LoginScreen.routeName);
          },
          child: Text(appLocalizations.login),
        )
      ],
    );
  }
}
