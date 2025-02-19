import 'package:flutter/material.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

class CustomGender extends StatefulWidget {
  final bool isSelected; // Determines if this option is selected
  final String labelText;
  final ValueChanged<bool> onChanged; // Callback to notify parent about change

  const CustomGender({
    super.key,
    required this.isSelected,
    required this.labelText,
    required this.onChanged,
  });

  @override
  State<CustomGender> createState() => _CustomGenderState();
}

class _CustomGenderState extends State<CustomGender> {
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: () {
        widget.onChanged(true);
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
              color: themeProvider.isDark()
                  ? AppColors.purple
                  : AppColors.gray), // Border color
          borderRadius: BorderRadius.circular(20), // Rounded border
          color: widget.isSelected
              ? AppColors.purple.withOpacity(0.1)
              : Colors.transparent, // Change color when selected
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                radioTheme: Theme.of(context).radioTheme,
              ),
              child: Radio<bool>(
                value: widget.isSelected,
                groupValue: true,
                onChanged: (_) {
                  widget.onChanged(true);
                },
              ),
            ),
            SizedBox(width: 8),
            Text(
              widget.labelText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
