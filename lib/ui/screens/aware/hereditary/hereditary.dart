import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
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

  Decoration boxDecoration() {
    return BoxDecoration(
      border: Border.all(color: AppColors.white),
      borderRadius: BorderRadius.circular(50),
    );
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    return DefaultTabController(
        length: 4,
        child: Scaffold(
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: AppColors.purple,
          //   shape: const CircleBorder(
          //     side: BorderSide(color: AppColors.white, width: 5),
          //   ),
          //   onPressed: () {},
          //   child: const ImageIcon(
          //     AssetImage(AppIcons.scanIcon),
          //   ),
          // ),
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
              tabs: [
                Tab(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: boxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(AssetImage(AppIcons.allIcon)),
                        SizedBox(
                          width: 8,
                        ),
                        Text(appLocalizations.all),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: boxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(AssetImage(AppIcons.awareFilled)),
                        SizedBox(
                          width: 8,
                        ),
                        Text(appLocalizations.breast),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: boxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(AssetImage(AppIcons.awareFilled)),
                        SizedBox(
                          width: 8,
                        ),
                        Text(appLocalizations.prostate),
                      ],
                    ),
                  ),
                ),
                Tab(
                    child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: boxDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageIcon(AssetImage(AppIcons.awareFilled)),
                      SizedBox(
                        width: 8,
                      ),
                      Text(appLocalizations.ovarian),
                    ],
                  ),
                ))
              ],
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
          //       activeIcon: const ImageIcon(AssetImage(AppIcons.menuFilled)),
          //     ),
          //   ],
          // ),
        ));
  }
}
