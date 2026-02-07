import 'package:flutter/material.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CustomTabSelector extends StatefulWidget {
  final Function(int index) onTabSelected;
  final int selectedIndex;

  const CustomTabSelector({
    required this.selectedIndex,
    required this.onTabSelected,
    super.key,
  });

  @override
  State<CustomTabSelector> createState() => _CustomTabSelectorState();
}

class _CustomTabSelectorState extends State<CustomTabSelector> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    final tabs = [appLocalizations.all, appLocalizations.byCategory];
    final colors = [Colors.purple.shade100, Colors.blue.shade100];
    final textColors = [AppColors.Teal, Colors.blue];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(tabs.length, (index) {
        final isSelected = widget.selectedIndex == index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: GestureDetector(
            onTap: () => widget.onTabSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? colors[index] : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                tabs[index],
                style: TextStyle(
                  color: isSelected ? textColors[index] : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
