import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
      tabBarTheme: TabBarTheme(
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.white),
          color: AppColors.white,
        ),
        dividerColor: Colors.transparent,
        unselectedLabelStyle: const TextStyle(color: AppColors.white),
        labelStyle: const TextStyle(color: AppColors.purple),
      ),
      brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    dividerColor: AppColors.purple,
    primaryColor: AppColors.purple,
    primaryColorDark: AppColors.dark,
    appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.purple,
      centerTitle: true,
      elevation: 0,
        iconTheme: IconThemeData(color: AppColors.white)),
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
      iconTheme: IconThemeData(color: AppColors.white),
      textTheme: const TextTheme(
        titleMedium: TextStyle(
            color: AppColors.white, fontSize: 26, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(
            color: AppColors.gray, fontSize: 12, fontWeight: FontWeight.w500),
        titleLarge: TextStyle(
            color: AppColors.dark, fontSize: 32, fontWeight: FontWeight.bold),
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
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.purple,
        selectedItemColor: AppColors.white,
        selectedLabelStyle: TextStyle(
          color: AppColors.white,
        ),
        unselectedItemColor: AppColors.white,
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
        labelStyle: const TextStyle(color: AppColors.purple),
      ),
      scaffoldBackgroundColor: AppColors.dark,
      dividerColor: AppColors.purple,
      dividerTheme: const DividerThemeData(
        color: AppColors.purple,
      ),
      bottomAppBarTheme:
          BottomAppBarTheme(color: AppColors.purple, elevation: 5),
      iconTheme: IconThemeData(color: AppColors.dark),
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
      appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.dark,
          foregroundColor: AppColors.purple,
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.dark)),
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
        titleSmall: TextStyle(
            color: AppColors.gray, fontSize: 12, fontWeight: FontWeight.w500),
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
        titleSmall: TextStyle(
            color: AppColors.gray, fontSize: 16, fontWeight: FontWeight.w500),
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
        selectedItemColor: AppColors.dark,
        selectedLabelStyle: TextStyle(
          color: AppColors.dark,
        ),
        unselectedItemColor: AppColors.dark,
      ),
    // floatingActionButtonTheme: FloatingActionButtonThemeData(
    //   backgroundColor: AppColors.purple,
    //   shape: CircleBorder(
    //     side: BorderSide(color: AppColors.dark, width: 5),
    //   ),
    // )
  );
}
