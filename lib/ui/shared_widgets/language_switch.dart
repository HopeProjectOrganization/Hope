import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:hope/core/providers/locale_provider.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LanguageSwitch extends StatelessWidget {
  LanguageSwitch({super.key});

  late LocaleProvider localeProvider;

  @override
  Widget build(BuildContext context) {
    localeProvider = Provider.of<LocaleProvider>(context);
    return AnimatedToggleSwitch<String>.rolling(
      current: localeProvider.locale,
      values: const ["ar", "en"],
      style: ToggleStyle(
        backgroundColor: Colors.transparent,
        indicatorColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
      ),
      onChanged: (value) {
        localeProvider.locale = value;
      },
      iconBuilder: (value, foreground) {
        if (value == "ar") {
          return Flag(Flags.egypt);
        } else {
          return Flag(Flags.united_states_of_america);
        }
      },
    );
  }
}
