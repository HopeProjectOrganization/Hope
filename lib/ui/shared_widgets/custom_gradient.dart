import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

class CustomGradient extends StatelessWidget {
  final Color color;

  const CustomGradient({super.key, this.color = AppColors.white});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.center,
          colors: [
            color.withOpacity(0.6),
            color.withOpacity(0.3),
          ],
          stops: [0.5, 1.0],
        ),
      ),
    ));
  }
}
