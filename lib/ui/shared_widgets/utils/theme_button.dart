import 'package:flutter/material.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ThemeButton extends StatelessWidget {
  ThemeButton({super.key});

  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return IconButton(
      onPressed: () {
        themeProvider.themeMode =
            themeProvider.isDark() ? ThemeMode.light : ThemeMode.dark;
      },
      icon: Icon(
        themeProvider.isDark() ? EvaIcons.moon : EvaIcons.sun,
        color: themeProvider.isDark() ? AppColors.dark : AppColors.white,
      ),
    );
  }
}
