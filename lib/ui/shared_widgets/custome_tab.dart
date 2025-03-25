import 'package:flutter/material.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/theme/app_colors.dart';


class CustomeTab extends StatefulWidget {
  final String text;
  final String icon;

  const CustomeTab({super.key,
    required this.text,
    this.icon = AppIcons.awareIcon});

  @override
  State<CustomeTab> createState() => _CustomeTabState();
}

class _CustomeTabState extends State<CustomeTab> {
  Decoration boxDecoration() {
    return BoxDecoration(
      border: Border.all(color: AppColors.white),
      borderRadius: BorderRadius.circular(50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: boxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(AssetImage(widget.icon)),
            SizedBox(
              width: 8,
            ),
            Text(widget.text),
          ],
        ),
      ),
    );
  }

}
