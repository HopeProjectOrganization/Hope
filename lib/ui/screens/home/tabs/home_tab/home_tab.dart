import 'package:flutter/material.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/home/home.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/scan_tab.dart';
import 'package:hope/ui/shared_widgets/custom_home_button.dart';
import 'package:hope/ui/shared_widgets/utils/language_button.dart';
import 'package:hope/ui/shared_widgets/utils/theme_button.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // Header section
          SafeArea(
            child: Container(
              width: double.infinity,
              height: 118,
              decoration: const BoxDecoration(
                color: AppColors.purple,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back ✨',
                              style: TextStyle(color: AppColors.white),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Hope',
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ThemeButton(),
                        const SizedBox(width: 10),
                        LanguageButton(),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  CustomHomeButton(
                    image: AppAssets.awareButton,
                    onClick: () {
                      Navigator.pushNamed(context, HomeScreen.routeName,
                          arguments: 2);
                    },
                  ),
                  CustomHomeButton(
                    image: AppAssets.scanButton,
                    onClick: () {
                      Navigator.pushNamed(
                        context,
                        ScanTab.routeName,
                      );
                    },
                  ),
                  CustomHomeButton(
                    image: AppAssets.chatbotButton,
                    onClick: () {
                      Navigator.pushNamed(context, HomeScreen.routeName,
                          arguments: 3);
                    },
                  ),
                  CustomHomeButton(
                    image: AppAssets.addButton,
                    onClick: () {
                      Navigator.pushNamed(
                          context, HomeScreen.routeName,
                          arguments: 1);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
