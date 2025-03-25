import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/shared_widgets/custome_tab.dart';
import 'package:provider/provider.dart';

class Hereditary extends StatefulWidget {
  static const routeName = '/hereditary';

  const Hereditary({super.key});

  @override
  State<Hereditary> createState() => _HereditaryState();
}

class _HereditaryState extends State<Hereditary> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;
  final List<String> cancerTypes = [
    "All",
    "breast",
    "lung",
    "leukemia",
    "prostate",
    "brain"
  ];
  String selectedCancerType = "All";

  List<Widget> buildTabs(List<String> types) {
    return types.map((type) => CustomeTab(text: type)).toList();
  }


  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    return DefaultTabController(
        length: cancerTypes.length,
        child: Scaffold(
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
            title: Text(
              appLocalizations.hereditary,
              style: TextStyle(color: AppColors.white),
            ),
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppColors.white),
                color: AppColors.white,
              ),
              isScrollable: true,
              dividerColor: Colors.transparent,
              unselectedLabelStyle: const TextStyle(color: AppColors.white),
              labelStyle: const TextStyle(color: AppColors.purple),
              tabs: buildTabs(cancerTypes),
            ),
          ),
          //    buildEventsListView()
          body: const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [],
              ),
            ),
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   type: BottomNavigationBarType.fixed,
          //   backgroundColor: AppColors.purple,
          //   selectedItemColor: AppColors.white,
          //   unselectedItemColor: AppColors.white,
          //   items: <BottomNavigationBarItem>[
          //     BottomNavigationBarItem(
          //       icon: const ImageIcon(AssetImage(AppIcons.homeIcon)),
          //       label: appLocalizations.home,
          //       backgroundColor: AppColors.purple,
          //       activeIcon: const ImageIcon(AssetImage(AppIcons.homeFilled)),
          //     ),
          //     BottomNavigationBarItem(
          //       icon: const ImageIcon(AssetImage(AppIcons.addIcon)),
          //       label: appLocalizations.add,
          //       backgroundColor: AppColors.purple,
          //       activeIcon: const ImageIcon(AssetImage(AppIcons.addFilled)),
          //     ),
          //     BottomNavigationBarItem(
          //       icon: const ImageIcon(AssetImage(AppIcons.awareIcon)),
          //       label: appLocalizations.aware,
          //       backgroundColor: AppColors.purple,
          //       activeIcon: const ImageIcon(AssetImage(AppIcons.awareFilled)),
          //     ),
          //     BottomNavigationBarItem(
          //       icon: const ImageIcon(AssetImage(AppIcons.menuIcon)),
          //       label: appLocalizations.menu,
          //       backgroundColor: AppColors.purple,
          //       activeI, String allIconcon: const ImageIcon(AssetImage(AppIcons.menuFilled)),
          //     ),
          //   ],
          // ),
        )
    );
  }

}
