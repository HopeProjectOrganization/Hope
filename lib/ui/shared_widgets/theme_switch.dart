import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedToggleSwitch<ThemeMode>.rolling(
        current: themeProvider.getCurrentTheme,
        values: const [ThemeMode.dark, ThemeMode.light, ThemeMode.system],
        style: ToggleStyle(
        backgroundColor: Colors.transparent,
        indicatorColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
      ),
        onChanged: (ThemeMode newTheme) {
          themeProvider.setThemeModeProvider(
              themeProvider.isDarkTheme ? ThemeMode.light : ThemeMode.dark);
        },
      iconBuilder: (value, foreground) {
          if (value == ThemeMode.dark) {
            return Icon(
              EvaIcons.moon,
              color: !themeProvider.isDark()
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).scaffoldBackgroundColor,
            );
          } else if (value == ThemeMode.light) {
            return Icon(
              EvaIcons.sun,
              color: themeProvider.isDark()
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).scaffoldBackgroundColor,
            );
          } else {
            return Visibility(
              visible: false,
              child: Container(),
            );
          }
        });
  }
}
