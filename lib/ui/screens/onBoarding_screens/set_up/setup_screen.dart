import 'package:flutter/material.dart';
// ignore: must_be_immutable
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/ui/screens/onBoarding_screens/on_boarding/onboarding_screen.dart';
import 'package:hope/ui/shared_widgets/language_switch.dart';
import 'package:hope/ui/shared_widgets/theme_switch.dart';
import 'package:provider/provider.dart';

//newBranch
// ignore: must_be_immutable
class SetupScreen extends StatelessWidget {
  static const String routeName = "/SetupScreen";

  late ThemeProvider themeProvider;

  late AppLocalizations appLocalizations;

  SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.asset(AppAssets.setup),
              ),
              const SizedBox(height: 16),
              Text(
                appLocalizations.setupTitle,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 16),
              Text(
                appLocalizations.setupDescription,
                //  appLocalizations.setupScreenDescription,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appLocalizations.language,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  LanguageSwitch()
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appLocalizations.theme,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  ThemeSwitch(),
                ],
              ),
              SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, OnBoardingScreen.routeName);
                },
                child: Text(appLocalizations.letsStart),
              )
            ],
          ),
        ),
      ),
    );
  }
}
