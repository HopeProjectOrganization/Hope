import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/providers/theme_provider.dart';

class MealSenceScreen extends StatefulWidget {
  static const String routeName = '/mealSence';

  @override
  _MealSenceScreen createState() => _MealSenceScreen();
}

class _MealSenceScreen extends State<MealSenceScreen>
    with SingleTickerProviderStateMixin {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
