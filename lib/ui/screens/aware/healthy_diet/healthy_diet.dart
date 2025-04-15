import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/aware/awareness/news_list.dart';
import 'package:hope/ui/shared_widgets/custome_tab.dart';
import 'package:provider/provider.dart';

class HealthyDiet extends StatefulWidget {
  static const routeName = '/healthyDiet';

  const HealthyDiet({super.key});

  @override
  State<HealthyDiet> createState() => _HealthyDietState();
}

class _HealthyDietState extends State<HealthyDiet>
    with SingleTickerProviderStateMixin {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  List<Widget> buildTabs(List<String> types) {
    return types.map((type) => CustomeTab(text: type)).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          backgroundColor: AppColors.purple,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          centerTitle: true,
          title: const Text(
            "Healthy Diet",
            style: TextStyle(color: AppColors.white),
          ),
        ),
        body: NewsList(type: "healthy diet prevent cancer"));
  }
}
