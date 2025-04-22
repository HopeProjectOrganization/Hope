import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final Function onClick;
  final String title;
  final Widget? icon;
  final Color? color;

  const CustomButton(
      {super.key,
      required this.title,
      this.color = AppColors.purple,
      required this.onClick,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        onPressed: () async {
          onClick();
        },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(color),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(title),
          if (icon != null) ...[
            icon!,
          ],
        ],
      ),
    );
  }
}
