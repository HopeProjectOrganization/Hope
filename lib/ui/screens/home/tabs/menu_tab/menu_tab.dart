import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/ui/shared_widgets/language_switch.dart';
import 'package:hope/ui/shared_widgets/theme_switch.dart';
import 'package:provider/provider.dart';

class MenuTab extends StatefulWidget {
  const MenuTab({super.key});

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations =
        AppLocalizations.of(context) ?? AppLocalizations.of(context)!;
    return SafeArea(
        child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(children: [
              Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(appLocalizations.language,
                          style: Theme.of(context).textTheme.labelLarge)),
                  LanguageSwitch()
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(appLocalizations.theme,
                          style: Theme.of(context).textTheme.labelLarge)),
                  ThemeSwitch(),
                ],
              ),
            ])));
  }

  void bottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(),
    );
  }
}
