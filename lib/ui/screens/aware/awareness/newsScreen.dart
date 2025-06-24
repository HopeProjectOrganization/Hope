import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/aware/awareness/news_list.dart';
import 'package:provider/provider.dart';

class NewsScreen extends StatefulWidget {
  static const String routeName = '/newsScreen';

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  final List<String> cancerTypes = [
    "All",
    "Breast",
    "Lung",
    "Prostate",
    "Colorectal",
    "Skin",
    "Ovarian",
    "Pancreatic",
    "Leukemia",
    "Lymphoma",
    "Brain",
    "Liver",
    "Stomach",
    "Esophageal",
    "Bladder",
    "Kidney",
    "Thyroid",
    "Bone",
    "Testicular",
    "Endometrial",
    "Cervical",
    "Gallbladder",
    "Multiple_Myeloma",
    "Oral"
  ];

  final List<String> hereditaryTypes = [
    "Breast",
    "Colorectal",
    "Ovarian",
    "Prostate",
    "Pancreatic",
  ];

  final List<String> highRiskTypes = [
    "Smokers",
    "Obese",
    "Elderly",
    "Pregnant",
    "Weak Immune System",
    "Genetic Mutation",
    "Inactive",
    "Chemical Exposure",
    "Polluted Areas",
  ];

  String selectedCancerType = "All";

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
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          )
        ],
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        backgroundColor: AppColors.Teal,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        centerTitle: true,
        title: const Text("News", style: TextStyle(color: AppColors.white)),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.6,
        backgroundColor: const Color(0xffd5eaff),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xffd5eaff)),
              child: Text("Select News Filter",
                  style: TextStyle(color: AppColors.dark, fontSize: 25)),
            ),
            buildCategorySection("Cancer Types", cancerTypes),
            buildCategorySection("Hereditary Cancer", hereditaryTypes),
            buildCategorySection("High Risk People", highRiskTypes),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.lavender.withOpacity(0.2),
            padding: const EdgeInsets.all(8),
            child:
                Text(selectedCancerType, style: const TextStyle(fontSize: 16)),
          ),
          Expanded(child: NewsList(type: selectedCancerType)),
        ],
      ),
    );
  }

  Widget buildCategorySection(String title, List<String> items) {
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
        unselectedWidgetColor: AppColors.white,
      ),
      child: ExpansionTile(
        title: Text(title, style: Theme.of(context).textTheme.titleSmall),
        iconColor: AppColors.yellow,
        collapsedIconColor: AppColors.yellow,
        children: items.map((type) {
          return ListTile(
            title: Text(
              type,
              style: TextStyle(
                color: selectedCancerType == type
                    ? AppColors.yellow
                    : themeProvider.isDark()
                        ? AppColors.dark
                        : AppColors.white,
                fontWeight: selectedCancerType == type
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            selected: selectedCancerType == type,
            onTap: () {
              setState(() {
                selectedCancerType = type;
              });
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}