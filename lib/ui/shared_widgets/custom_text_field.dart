import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? iconData;
  final int minLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.iconData,
    this.suffixIcon,
    this.prefixIcon,
    this.minLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          style: Theme.of(context).textTheme.bodyLarge,
          cursorColor: Theme.of(context).primaryColor,
          controller: controller,
          minLines: minLines,
          maxLines: 6,
          decoration: InputDecoration(
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: prefixIcon, // Display the provided prefixIcon
                  )
                : (iconData != null ? Icon(iconData) : null),
            hintMaxLines: minLines,
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
