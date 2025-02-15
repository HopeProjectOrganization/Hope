import 'package:flutter/material.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/theme/app_colors.dart';

class Hereditary extends StatefulWidget {
  static const routeName = '/hereditary';

  const Hereditary({super.key});

  @override
  State<Hereditary> createState() => _HereditaryState();
}

class _HereditaryState extends State<Hereditary> {
  Decoration boxDecoration() {
    return BoxDecoration(
      border: Border.all(color: AppColors.white),
      borderRadius: BorderRadius.circular(50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.purple,
            shape: const CircleBorder(
              side: BorderSide(color: AppColors.white, width: 5),
            ),
            onPressed: () {},
            child: const ImageIcon(
              AssetImage(AppIcons.scanIcon),
              color: AppColors.white,
            ),
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
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
              "Hereditary",
              style: TextStyle(color: AppColors.white),
            ),
            bottom: TabBar(
              unselectedLabelColor: AppColors.white,
              labelColor: AppColors.purple,
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(AssetImage(AppIcons.allIcon)),
                        SizedBox(
                          width: 8,
                        ),
                        Text("all"),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: boxDecoration(),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(AssetImage(AppIcons.awareFilled)),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Breast"),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: boxDecoration(),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(AssetImage(AppIcons.awareFilled)),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Prostate"),
                      ],
                    ),
                  ),
                ),
                Tab(
                    child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: boxDecoration(),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageIcon(AssetImage(AppIcons.awareFilled)),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Ovarian"),
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
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.purple,
            selectedItemColor: AppColors.white,
            unselectedItemColor: AppColors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(AppIcons.homeIcon)),
                label: 'Home',
                backgroundColor: AppColors.purple,
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(AppIcons.addIcon)),
                label: 'Add',
                backgroundColor: AppColors.purple,
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(AppIcons.awareIcon)),
                label: 'Aware',
                backgroundColor: AppColors.purple,
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(AppIcons.menuIcon)),
                label: 'Menu',
                backgroundColor: AppColors.purple,
              ),
            ],
          ),
        ));
  }
}
