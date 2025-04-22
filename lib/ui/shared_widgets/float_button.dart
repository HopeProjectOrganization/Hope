import 'package:flutter/material.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/theme/app_colors.dart';

class FloatButton extends StatefulWidget {
  const FloatButton({super.key});

  @override
  State<FloatButton> createState() => _FloatButtonState();
}

class _FloatButtonState extends State<FloatButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'chatbot',
      onPressed: () {},
      backgroundColor: AppColors.purple,
      child: Image.asset(AppIcons.chatbot),
    );
  }
}
