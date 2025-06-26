import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    tabBarTheme: TabBarTheme(
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.Teal,
        border: Border.all(color: AppColors.Teal),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: Colors.white,
      unselectedLabelColor: AppColors.Teal,
      dividerColor: Colors.transparent,
    ),

    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    dividerColor: AppColors.Teal,
    primaryColor: AppColors.Teal,
    primaryColorDark: AppColors.dark,
    appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
        foregroundColor: AppColors.Teal,
        centerTitle: true,
      elevation: 0,
        iconTheme: IconThemeData(color: AppColors.white)),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.Teal;
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
    bottomAppBarTheme: BottomAppBarTheme(color: AppColors.dark, elevation: 5),
    iconTheme: IconThemeData(color: AppColors.white),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          fontSize: 40,
          height: 1,
          fontWeight: FontWeight.bold,
          color: AppColors.dark),
      titleMedium: TextStyle(
          color: AppColors.white, fontSize: 26, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(
          color: AppColors.dark, fontSize: 16, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(
          color: AppColors.dark, fontSize: 16, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(
          color: AppColors.Teal, fontSize: 14, fontWeight: FontWeight.w500),
      bodySmall: TextStyle(
          color: AppColors.dark, fontSize: 12, fontWeight: FontWeight.w500),
      labelLarge: TextStyle(
          color: AppColors.dark, fontSize: 24, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(
          color: AppColors.dark, fontSize: 20, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(
          color: AppColors.dark, fontSize: 16, fontWeight: FontWeight.bold),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.Teal,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.Teal,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            foregroundColor: AppColors.Teal,
            textStyle: const TextStyle(
                color: AppColors.Teal,
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
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.Teal,
      selectedLabelStyle: TextStyle(
        color: AppColors.Teal,
      ),
      unselectedItemColor: AppColors.dark,
    ),
    // floatingActionButtonTheme: FloatingActionButtonThemeData(
    //   backgroundColor: AppColors.purple,
    //   shape: CircleBorder(
    //     side: BorderSide(color: AppColors.white, width: 5),
    //)   ),
  );

  static ThemeData darkTheme = ThemeData(
      tabBarTheme: TabBarTheme(
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.dark),
          color: AppColors.dark,
        ),
        dividerColor: Colors.transparent,
        unselectedLabelStyle: const TextStyle(color: AppColors.white),
      labelStyle: const TextStyle(color: AppColors.Teal),
    ),
      scaffoldBackgroundColor: AppColors.dark,
    dividerColor: AppColors.Teal,
    dividerTheme: const DividerThemeData(
      color: AppColors.Teal,
    ),
      bottomAppBarTheme: BottomAppBarTheme(color: AppColors.Teal, elevation: 5),
    iconTheme: IconThemeData(color: AppColors.dark),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
          return AppColors.Teal;
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
      appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.dark,
        foregroundColor: AppColors.Teal,
        centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.dark)),
    primaryColor: AppColors.Teal,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          color: AppColors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
          height: 1),
      titleMedium: TextStyle(
          color: AppColors.gray, fontSize: 26, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(
          color: AppColors.Teal, fontSize: 14, fontWeight: FontWeight.w500),
        bodySmall: TextStyle(
            color: AppColors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500),
        titleSmall: TextStyle(
          color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500),
      labelLarge: TextStyle(
          color: AppColors.white, fontSize: 24, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(
          color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(
          color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
    ),
    primaryTextTheme: const TextTheme(
        titleMedium: TextStyle(
          color: AppColors.gray, fontSize: 16, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(
          color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w500),
    ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
        backgroundColor: AppColors.Teal,
        foregroundColor: AppColors.dark,
        padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.Teal,
            textStyle: const TextStyle(
                color: AppColors.Teal,
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
        borderSide: const BorderSide(color: AppColors.Teal, width: 1),
      ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.Teal, width: 1),
      ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.Teal, width: 1),
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
      backgroundColor: AppColors.dark,
      selectedItemColor: AppColors.Teal,
      selectedLabelStyle: TextStyle(
        color: AppColors.dark,
        ),
      unselectedItemColor: AppColors.white,
    ),
    // floatingActionButtonTheme: FloatingActionButtonThemeData(
    //   backgroundColor: AppColors.purple,
    //   shape: CircleBorder(
    //     side: BorderSide(color: AppColors.dark, width: 5),
    //   ),
    // )
  );
}
