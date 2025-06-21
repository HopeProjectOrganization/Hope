import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/aware/awareness/news_list.dart';
import 'package:hope/ui/shared_widgets/custome_tab.dart';
import 'package:provider/provider.dart';

class HighRiskPeople extends StatefulWidget {
  static const String routeName = '/highRisk';

  @override
  _HighRiskPeopleState createState() => _HighRiskPeopleState();
}

class _HighRiskPeopleState extends State<HighRiskPeople>
    with SingleTickerProviderStateMixin {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  late TabController _tabController;

  final List<String> highRiskPeople = [
    "All",
    'Elderly',
    'Pregnant',
    'Weak immune system',
    'Smokers',
    'Obese',
    'Genetic mutation',
    'Inactive',
    'Chemical exposure',
    'Polluted areas',
  ];

  String selectedCancerType = "All";

  List<Widget> buildTabs(List<String> types) {
    return types.map((type) => CustomeTab(text: type)).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: highRiskPeople.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedCancerType = highRiskPeople[_tabController.index];
      });
    });
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
        backgroundColor: AppColors.Teal,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        centerTitle: true,
        title: Text(
          "High Risk People",
          style: TextStyle(color: AppColors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: true,
          labelPadding: const EdgeInsets.symmetric(horizontal: 7),
          padding: const EdgeInsets.symmetric(vertical: 10),
          tabs: buildTabs(highRiskPeople),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: highRiskPeople
            .map((type) => NewsList(type: "$type at high risk of cancer"))
            .toList(),
      ),
    );
  }
}
