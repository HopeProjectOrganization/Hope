import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

class CustomGender extends StatefulWidget {
  final bool isChecked;
  final String labelText;
  final ValueChanged<bool>? onChanged; // Callback to notify parent

  const CustomGender({
    super.key,
    required this.isChecked,
    required this.labelText,
    this.onChanged,
  });

  @override
  State<CustomGender> createState() => _CustomGenderState();
}

class _CustomGenderState extends State<CustomGender> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked; // Initialize state from widget property
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked; // Toggle checked state
        });
        widget.onChanged?.call(isChecked); // Notify parent about change
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), // Border color
          borderRadius: BorderRadius.circular(20), // Rounded border
          color: isChecked
              ? AppColors.purple.withOpacity(0.2)
              : Colors.transparent, // Change color when selected
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.labelText,
              style: const TextStyle(
                fontSize: 16, // Change text color when selected
              ),
            ),
            const SizedBox(width: 8), // Space between text and checkbox
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value ?? false;
                });
                widget.onChanged?.call(isChecked);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)), // Rounded checkbox
              activeColor: AppColors.purple, // Color when checked
            ),
          ],
        ),
      ),
    );
  }
}
