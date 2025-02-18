import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(true);
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray), // Border color
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
                radioTheme: RadioThemeData(
                  fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.selected)) {
                      return AppColors.purple;
                    }
                    return AppColors
                        .gray; // The border circle color when not selected
                  }),
                  overlayColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.hovered)) {
                      return AppColors.gray; // Optional hover color
                    }
                    return Colors.transparent; // No overlay otherwise
                  }),
                ),
              ),
              child: Radio<bool>(
                value: widget.isSelected,
                groupValue: true, // Always selected in this widget
                onChanged: (_) {
                  widget.onChanged(true); // Notify parent when selected
                },
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.labelText,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
