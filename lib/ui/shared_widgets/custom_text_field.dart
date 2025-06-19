import 'package:flutter/material.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  late ThemeProvider themeProvider;

  final TextEditingController controller;
  final String hint;
  final IconData? iconData;
  final int minLines;
  final String? error;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;

  CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.iconData,
    this.error,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.minLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);

    return Stack(
      children: [
        TextFormField(
          validator: validator,
          style: Theme.of(context).textTheme.bodyLarge,
          cursorColor: Theme.of(context).primaryColor,
          controller: controller,
          minLines: minLines,
          maxLines: minLines > 1 ? minLines : 1,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            hintMaxLines: minLines,
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: error != null
                      ? AppColors.red
                      : themeProvider.isDark()
                          ? AppColors.purple
                          : AppColors.dark),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: error != null ? AppColors.red : AppColors.purple),
              borderRadius: BorderRadius.circular(16),
            ),
            errorText: error,
            errorStyle: const TextStyle(color: AppColors.red),
          ),
        ),
        Positioned(
          right: 8, // Padding from the right
          top: 8, // Padding from the top
          child: suffixIcon ?? Container(),
        ),
      ],
    );
  }
}
