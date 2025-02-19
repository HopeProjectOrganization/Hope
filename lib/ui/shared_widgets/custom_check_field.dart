import 'package:flutter/material.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

class CustomCheckField extends StatefulWidget {
  final int width;
  final bool isChecked;
  final String labelText;
  final ValueChanged<bool>? onChanged; // Callback to notify parent

  const CustomCheckField({
    super.key,
    required this.width,
    required this.isChecked,
    required this.labelText,
    this.onChanged,
  });

  @override
  State<CustomCheckField> createState() => _CustomCheckFieldState();
}

class _CustomCheckFieldState extends State<CustomCheckField> {
  late bool isChecked;
  late ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked; // Initialize state from widget property
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked; // Toggle checked state
        });
        widget.onChanged?.call(isChecked); // Notify parent about change
      },
      child: Container(
        width: widget.width.toDouble(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
              color: themeProvider.isDark()
                  ? AppColors.purple
                  : AppColors.gray), // Border color
          borderRadius: BorderRadius.circular(20), // Rounded border
          color: isChecked
              ? AppColors.purple.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                widget.labelText,
                style: Theme.of(context).primaryTextTheme.titleMedium,
                softWrap: true, // Allows text to wrap
                overflow: TextOverflow.visible, // Prevents clipping
              ),
            ),
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value ?? false;
                });
                widget.onChanged?.call(isChecked);
              },
              side: BorderSide(
                  color:
                      themeProvider.isDark() ? AppColors.white : AppColors.gray,
                  width: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              // Rounded checkbox
              activeColor: AppColors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
