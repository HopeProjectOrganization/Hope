import 'package:flutter/material.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold(
      {super.key,
      required this.title,
      this.actions,
      this.body,
      this.backgroundColor});

  final String title;
  final List<Widget>? actions;
  final Widget? body;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDark();

    return Scaffold(
      backgroundColor:
          backgroundColor ?? (isDarkMode ? AppColors.dark : backgroundColor),
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.dark : AppColors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined,
              color: isDarkMode ? AppColors.white : AppColors.dark),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(title),
        centerTitle: true,
        actions: actions,
      ),
      body: body,
    );
  }
}
