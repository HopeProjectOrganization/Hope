import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ThemeSwitch extends StatelessWidget {
  ThemeSwitch({super.key});

  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return AnimatedToggleSwitch<ThemeMode>.rolling(
      current: themeProvider.themeMode,
      values: const [ThemeMode.dark, ThemeMode.light],
      style: ToggleStyle(
        backgroundColor: Colors.transparent,
        indicatorColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
      ),
      onChanged: (value) {
        themeProvider.themeMode = value;
      },
      iconBuilder: (value, foreground) {
        if (value == ThemeMode.dark) {
          return Icon(
            EvaIcons.moon,
            color: !themeProvider.isDark()
                ? Theme.of(context).primaryColor
                : Theme.of(context).scaffoldBackgroundColor,
          );
        } else {
          return Icon(
            EvaIcons.sun,
            color: themeProvider.isDark()
                ? Theme.of(context).primaryColor
                : Theme.of(context).scaffoldBackgroundColor,
          );
        }
      },
    );
  }
}
