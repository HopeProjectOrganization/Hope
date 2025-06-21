import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/auth/login/login.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  static const String routeName = "/onBoarding";

  const OnBoardingScreen({super.key});

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  late ThemeProvider themeProvider;

  late AppLocalizations appLocalizations;

  final PageController pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations =
        AppLocalizations.of(context) ?? AppLocalizations.of(context)!;

    final List<Map<String, String>> onboardingData = [
      {
        "image": AppAssets.scanOnBoarding,
        "title": appLocalizations.onBoardingTitle1,
        "description": appLocalizations.onBoardingDescription1
      },
      {
        "image": AppAssets.addOnBoardingLight,
        "darkImage" : AppAssets.addOnBoardingDark,
        "title": appLocalizations.onBoardingTitle2,
        "description": appLocalizations.onBoardingDescription2
      },
      {
        "image": AppAssets.awareOnBoarding,
        "title": appLocalizations.onBoardingTitle3,
        "description": appLocalizations.onBoardingDescription3
      },
      {
        "image": AppAssets.chatbotOnBoarding,
        "title": appLocalizations.onBoardingTitle4,
        "description": appLocalizations.onBoardingDescription4
      },
      {
        "image": AppAssets.healthy,
        "title": appLocalizations.healthyDiet,
        "description": appLocalizations.onBoardingDescription5
      },
      {
        "image": AppAssets.meals,
        "title": appLocalizations.mealSense,
        "description": appLocalizations.onBoardingDescription6
      },
    ];

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return (buildScreen(context, onboardingData, index));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildScreen(BuildContext context,
      List<Map<String, String>> onboardingData, int index) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
             Image.asset(
               themeProvider.isDark()&& index==1 ?
                onboardingData[index]["darkImage"]! :
               onboardingData[index]["image"]!,
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height * 0.4,
              ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  onboardingData[index]["title"]!,
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            onboardingData[index]["description"]!,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Spacer(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            currentIndex > 0
                ? TextButton(
                    onPressed: () {
                      if (currentIndex > 0) {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.Teal, width: 1), // Purple border
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.arrow_back_outlined,
                            color: AppColors.Teal),
                      ),
                    ))
                : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(onboardingData.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: currentIndex == index ? 16.0 : 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      color: currentIndex == index ? AppColors.Teal : Colors.grey,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  );
                }),
              ),
            ),
            TextButton(
                onPressed: () {
                  if (currentIndex < onboardingData.length) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pushReplacementNamed(
                        context, LoginScreen.routeName);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.Teal, width: 1), // Purple border
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.arrow_forward_outlined,
                        color: AppColors.Teal),
                  ),
                )),
          ]),
        ],
      ),
    );
  }
}
