import 'package:flutter/material.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/chatbot/chat.dart';

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
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
        );
      },
      backgroundColor: AppColors.Teal,
      child: Image.asset(AppIcons.chatbot),
    );
  }
}
