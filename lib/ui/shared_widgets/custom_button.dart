import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onClick;
  final String title;

  const CustomButton({super.key, required this.title, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        onPressed: () async {
          onClick();
        },
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12)),
        child: Text(title));
  }
}
