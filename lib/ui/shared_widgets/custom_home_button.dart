import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

class CustomHomeButton extends StatelessWidget {
  final Function onClick;
  final String image;

  const CustomHomeButton(
      {super.key, required this.image, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.Teal),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
