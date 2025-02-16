import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomLabel({
    super.key,
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyLarge,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: Padding(
          // ignore: prefer_const_constructors
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: suffixIcon,
        ),
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
    );
  }
}
