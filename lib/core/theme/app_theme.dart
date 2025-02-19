import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    dividerColor: AppColors.purple,
    primaryColor: AppColors.purple,
    primaryColorDark: AppColors.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.purple,
      centerTitle: true,
      elevation: 0,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.purple;
        }
        return AppColors.gray;
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.hovered)) {
          return AppColors.gray;
        }
        return Colors.transparent;
      }),
    ),
    primaryTextTheme: const TextTheme(
      titleMedium: TextStyle(
          color: AppColors.gray, fontSize: 16, fontWeight: FontWeight.w500),
    ),
    bottomAppBarTheme: BottomAppBarTheme(color: AppColors.purple, elevation: 5),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          color: AppColors.dark, fontSize: 16, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(
          color: AppColors.dark, fontSize: 14, fontWeight: FontWeight.w500),
      bodySmall: TextStyle(
          color: AppColors.dark, fontSize: 12, fontWeight: FontWeight.w500),
      labelLarge: TextStyle(
          color: AppColors.purple, fontSize: 22, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(
          color: AppColors.purple, fontSize: 20, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(
          color: AppColors.purple, fontSize: 16, fontWeight: FontWeight.bold),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.purple,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.purple,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            foregroundColor: AppColors.purple,
            textStyle: const TextStyle(
                color: AppColors.purple,
                decoration: TextDecoration.underline,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20))),
    inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: AppColors.gray,
        suffixIconColor: AppColors.gray,
        hintStyle: const TextStyle(
            fontSize: 16, color: AppColors.gray, fontWeight: FontWeight.w500),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.gray, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.gray, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.gray, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.red, width: 1),
        )),
  );

  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: AppColors.dark,
      dividerColor: AppColors.purple,
      dividerTheme: const DividerThemeData(
        color: AppColors.purple,
      ),
      bottomAppBarTheme:
          BottomAppBarTheme(color: AppColors.purple, elevation: 5),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.purple;
          }
          return AppColors.white;
        }),
        overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.hovered)) {
            return AppColors.white;
          }
          return Colors.transparent;
        }),
      ),
      primaryColor: AppColors.purple,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500),
        bodySmall: TextStyle(
            color: AppColors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500),
        labelLarge: TextStyle(
            color: AppColors.purple, fontSize: 22, fontWeight: FontWeight.bold),
        labelMedium: TextStyle(
            color: AppColors.purple, fontSize: 20, fontWeight: FontWeight.bold),
        labelSmall: TextStyle(
            color: AppColors.purple, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      primaryTextTheme: const TextTheme(
        titleMedium: TextStyle(
            color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.purple,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.dark,
        foregroundColor: AppColors.purple,
        centerTitle: true,
        elevation: 0,
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: AppColors.purple,
              textStyle: const TextStyle(
                  color: AppColors.purple,
                  decoration: TextDecoration.underline,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 20))),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: AppColors.white,
        suffixIconColor: AppColors.white,
        hintStyle: const TextStyle(
            fontSize: 16,
            color: AppColors.white,
            fontWeight: FontWeight.w500),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.purple, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.purple, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.purple, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.red, width: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.purple,
      ));
}
