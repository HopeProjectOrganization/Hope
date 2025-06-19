import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/auth/register/register_service.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/avatar.dart';
import 'package:hope/ui/screens/auth/login/login.dart';
import 'package:hope/ui/shared_widgets/custom_check_field.dart';
import 'package:hope/ui/shared_widgets/custom_drop_down.dart';
import 'package:hope/ui/shared_widgets/custom_gender.dart';
import 'package:hope/ui/shared_widgets/custom_text_field.dart';
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
  final PageController _pageController =
      PageController(initialPage: 5, viewportFraction: 0.5);

  final RegisterService authService = RegisterService();

  double currentPage = 5.0;
  int selectedAvatarId = Avatar.avatars[5]['id'];

  DateTime selectedDate = DateTime.now();
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var repasswordController = TextEditingController();

  bool _obscureConfirmPassword = true;

  String? _passwordMatchError;
  String? _emptyFieldError;

  bool? isMale;
  bool smoke = false;
  bool haveCancer = false;
  bool familyCancer = false;

  String cancerType = 'None';
  String familyCancerType = 'None';

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
            Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: PageView.builder(
                        controller: _pageController,
                        itemCount: Avatar.avatars.length,
                        onPageChanged: (index) {
                          setState(() {
                            selectedAvatarId = Avatar.avatars[index]['id'];
                            currentPage = index.toDouble();
                          });
                        },
                        itemBuilder: (context, index) {
                          double distanceFromCenter =
                              (currentPage - index).abs();
                          double scaleFactor =
                              (1 - distanceFromCenter * 0.4).clamp(0.4, 1.0);
                          double widthFactor =
                              (1 - distanceFromCenter * 0.03).clamp(0.4, 1.0);
                          return Center(
                              child: Transform.scale(
                            scale: scaleFactor,
                            child: Container(
                              width: MediaQuery.of(context).size.width *
                                  0.35 *
                                  widthFactor,
                              child:
                                  Image.asset(Avatar.avatars[index]['asset']),
                            ),
                          ));
                        }))),
            // Image.asset(
            //   AppAssets.register,
            //   height: MediaQuery.of(context).size.height * 0.3,
            // ),
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
            buildPasswordTextField(context),
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

  bool _obscurePassword = true;
  List<String> passwordHints = [];
  int passwordStrength = 0;

  List<String> getPasswordErrors(String password) {
    List<String> errors = [];
    passwordStrength = 0;

    if (password.length >= 8) {
      errors.add("✅ At least 8 characters");
      passwordStrength++;
    } else {
      errors.add("❌ At least 8 characters");
    }

    if (RegExp(r'[A-Z]').hasMatch(password)) {
      errors.add("✅ Has uppercase letter");
      passwordStrength++;
    } else {
      errors.add("❌ At least one uppercase letter");
    }

    if (RegExp(r'[a-z]').hasMatch(password)) {
      errors.add("✅ Has lowercase letter");
      passwordStrength++;
    } else {
      errors.add("❌ At least one lowercase letter");
    }

    if (RegExp(r'\d').hasMatch(password)) {
      errors.add("✅ Has number");
      passwordStrength++;
    } else {
      errors.add("❌ At least one number");
    }

    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      errors.add("✅ Has special character");
      passwordStrength++;
    } else {
      errors.add("❌ At least one special character (!@#\$&*~)");
    }

    return errors;
  }

  Widget buildPasswordTextField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: passwordController,
          obscureText: _obscurePassword,
          onChanged: (value) {
            setState(() {
              passwordHints = getPasswordErrors(value);
            });
          },
          decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (passwordController.text.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: passwordStrength / 5,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                passwordStrength <= 2
                    ? AppColors.red
                    : passwordStrength == 3 || passwordStrength == 4
                        ? Colors.orange
                        : Colors.green,
              ),
            ),
          ),
        if (passwordController.text.isNotEmpty) const SizedBox(height: 12),
        if (passwordController.text.isNotEmpty)
          if (passwordHints.isNotEmpty)
            Card(
              elevation: 2,
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: passwordHints.map((hint) {
                    final isValid = hint.startsWith("✅");
                    return Row(
                      children: [
                        Icon(
                          isValid ? Icons.check_circle : Icons.cancel,
                          size: 18,
                          color: isValid ? Colors.green : AppColors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          hint.replaceFirst("✅ ", "").replaceFirst("❌ ", ""),
                          style: TextStyle(
                            color: isValid ? Colors.green : AppColors.red,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
      ],
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
        authService.registerUser(
          name: usernameController.text,
          imageId: selectedAvatarId,
          context: context,
          username: usernameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          phone: phoneController.text.trim(),
          isMale: isMale,
          smoker: smoke,
          haveCancer: haveCancer,
          cancerType: cancerType,
          haveAFamilyCancer: familyCancer,
          familyType: familyCancerType,
          dateOfBirth: selectedDate,
        );
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
