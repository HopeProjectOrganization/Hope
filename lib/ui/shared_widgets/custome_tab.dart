import 'package:flutter/material.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/theme/app_colors.dart';

class CustomeTab extends StatelessWidget {
  final String text;
  final String icon;
  final bool isSelected;

  const CustomeTab({
    super.key,
    required this.text,
    this.icon = AppIcons.awareIcon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    double tabWidth = MediaQuery.of(context).size.width / 3;

    return Tab(
      child: Container(
        width: tabWidth,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.white),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ImageIcon(
            //   AssetImage(icon),
            //   color: isSelected ? AppColors.Teal : AppColors.white,
            // ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? AppColors.Teal : AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
