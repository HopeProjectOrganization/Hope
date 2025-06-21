import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Admin/aware/awareness/addNewsScreen.dart';
import 'package:hope/Admin/aware/awareness/news_list.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/shared_widgets/custome_tab.dart';
import 'package:provider/provider.dart';

class AdminNewsScreen extends StatefulWidget {
  static const String routeName = '/adminNewsScreen';

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<AdminNewsScreen>
    with SingleTickerProviderStateMixin {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  late TabController _tabController;

  // ✅ أنواع السرطان اللي موجودة في الـ API فقط
  final List<String> cancerTypes = [
    "ALL",
    "BREAST",
    "OVARIAN",
    "PROSTATE",
    "MELANOMA",
  ];

  String selectedCancerType = "ALL";

  List<Widget> buildTabs(List<String> types) {
    return types.map((type) => CustomeTab(text: type)).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: cancerTypes.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedCancerType = cancerTypes[_tabController.index];
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
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        backgroundColor: AppColors.Teal,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        centerTitle: true,
        title: Text("News", style: TextStyle(color: AppColors.white)),
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: true,
          labelPadding: const EdgeInsets.symmetric(horizontal: 7),
          padding: const EdgeInsets.symmetric(vertical: 10),
          tabs: buildTabs(cancerTypes),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: cancerTypes.map((type) => AdminNewsList(type: type)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AdminNewsEditorScreen.routeName);
        },
        backgroundColor: AppColors.Teal,
        child: const Icon(
          Icons.add,
          color: AppColors.lavender,
        ),
      ),
    );
  }
}
