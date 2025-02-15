import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/auth/login/login.dart';
import 'package:hope/ui/shared_widgets/custom_check_field.dart';
import 'package:hope/ui/shared_widgets/custom_drop_down.dart';
import 'package:hope/ui/shared_widgets/custom_label.dart';
import 'package:icons_plus/icons_plus.dart';
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
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var repasswordController = TextEditingController();

  bool male = false;
  bool female = false;

  bool smoke = false;
  bool hadCancer = false;
  bool familyCancer = false;
  bool obscurePassword = true;
  bool obscureReassword = true;
  //late UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;
    // userProvider = context.userProvider;
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
            CustomLabel(
                controller: nameController,
                hint: appLocalizations.username,
                prefixIcon: const ImageIcon(
                  AssetImage(AppIcons.emailIcon),
                )),
            const SizedBox(height: 16),
            CustomLabel(
              controller: emailController,
              hint: appLocalizations.email,
              prefixIcon: const ImageIcon(AssetImage(AppIcons.emailIcon) ,),
            ),
            const SizedBox(height: 16),
            CustomLabel(
              controller: phoneController,
              hint: appLocalizations.phone,
              prefixIcon: const ImageIcon(AssetImage(AppIcons.phoneIcon)),
            ),
            const SizedBox(height: 16),
            InkWell(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: themeProvider.isDark()
                              ? AppColors.purple
                              : AppColors.gray),
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
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          "${selectedDate.year} / ${selectedDate.month} / ${selectedDate.day}",
                          style: Theme.of(context).primaryTextTheme.titleMedium,
                        )
                      ],
                    )),
                onTap: () async {
                  setState(() {});
                }),
            const SizedBox(height: 16),
            CustomLabel(
              controller: passwordController,
              hint: appLocalizations.password,
              prefixIcon: const ImageIcon(AssetImage(AppIcons.passwordIcon)),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            CustomLabel(
              controller: repasswordController,
              hint: appLocalizations.confirmPassword,
              suffixIcon: const Icon(EvaIcons.eye),
              prefixIcon: const ImageIcon(AssetImage(AppIcons.passwordIcon)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CustomCheckField(
                    width: 150,
                    labelText: appLocalizations.female,
                    isChecked: female),
                const Spacer(),
                CustomCheckField(
                    width: 150,
                    labelText: appLocalizations.male,
                    isChecked: male),
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
                isChecked: hadCancer,
                labelText: appLocalizations.hadCancer,
                onChanged: (value) {
                  setState(() {
                    hadCancer = value;
                  });
                }),
            const SizedBox(height: 16),
            if (hadCancer) const CustomDropDown(),
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
            const SizedBox(height: 16),
            if (familyCancer) const CustomDropDown(),
            const SizedBox(height: 32),
            buildRegisterButton(context),
            buildSignInTextRow(context)
          ],
        ),
      ),
    );
  }

  FilledButton buildRegisterButton(BuildContext context) => FilledButton(
      onPressed: () {}
      //async {
      //   try {
      //     showLoading(context);
      //     final userCredentials =
      //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
      //       email: emailController.text,
      //       password: passwordController.text,
      //     );
      //     UserDM newUser = UserDM(
      //         id: userCredentials.user!.uid,
      //         name: nameController.text,
      //         email: emailController.text);
      //     await createUserInFirestore(newUser);
      //     userProvider
      //         .updateCurrentUser(await getUserFromFirestore(newUser.id));
      //     hideLoading(context);
      //   } on FirebaseAuthException catch (e) {
      //     hideLoading(context);
      //     String message = "Something went wrong please try again later";
      //     if (e.code == 'weak-password') {
      //       message = "The password provided is too weak.";
      //     } else if (e.code == 'email-already-in-use') {
      //       message = "The account already exists for that email.";
      //     } else {
      //       message = e.message ?? message;
      //     }
      //     showMessage(context, message, posButtonTitle: "ok", title: "Error");
      //   }
      //   // catch (e) {
      //   //   print(e);
      //   //   hideLoading(context);
      //   //   showMessage(context, e.toString(), posButtonTitle: "ok", title: "Error");
      //   // }
      // }
      ,
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
