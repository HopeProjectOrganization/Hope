import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/Api/auth/auth.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/avatar.dart';
import 'package:hope/model/register_dm.dart';
import 'package:hope/ui/screens/auth/login/login.dart';
import 'package:hope/ui/shared_widgets/custom_check_field.dart';
import 'package:hope/ui/shared_widgets/custom_drop_down.dart';
import 'package:hope/ui/shared_widgets/custom_gender.dart';
import 'package:hope/ui/shared_widgets/custom_text_field.dart';
import 'package:hope/ui/shared_widgets/password.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
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


  double currentPage = 5.0;
  int selectedAvatarId = Avatar.avatars[5]['id'];

  DateTime selectedDate = DateTime.now();
  var usernameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var repasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

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
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
// هنا التعديل المهم
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
                        ? AppColors.Teal
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

            PasswordWithConfirmField(
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
            ),

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

  FilledButton buildRegisterButton(BuildContext context) => FilledButton(
        onPressed: () async {
          final request = RegisterRequestModel(
            name: usernameController.text.trim(),
            username: usernameController.text.trim(),
            email: emailController.text.trim(),
            imageId: selectedAvatarId,
            password: passwordController.text.trim(),
            phone: phoneController.text.trim(),
            isMale: isMale,
            smoker: smoke,
            haveCancer: haveCancer,
            cancerType: cancerType,
            haveAFamilyCancer: familyCancer,
            familyType: familyCancerType,
            dateOfBirth: DateFormat('yyyy-MM-dd').format(selectedDate),
          );

          final service = AuthApiService();

          showLoading(context);
          final response = await service.register(request: request);
          hideLoading(context);

          if (response.statusCode == 200) {
            showMessage(
              context,
              "You have been successfully registered!",
              title: "Success",
              posButtonTitle: "Done",
              posButtonClick: () {
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
            );
          } else {
            showMessage(
              context,
              "Error during registration: ${response.statusCode}",
              title: "Error",
            );
          }
        },
        child: Text(appLocalizations.createAccount),
      );

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
