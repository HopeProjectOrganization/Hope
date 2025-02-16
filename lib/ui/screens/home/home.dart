import 'package:flutter/material.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/home/tabs/add_tab/add_tab.dart';
import 'package:hope/ui/screens/home/tabs/aware_tab/aware_tab.dart';
import 'package:hope/ui/screens/home/tabs/home_tab/home_tab.dart';
import 'package:hope/ui/screens/home/tabs/menu_tab/menu_tab.dart';
class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String scannedBarcode = "Not scanned yet";

  List<Widget> tabs = [
    const HomeTab(),
    // AddTab(),
    AwareTab(),
    const MenuTab(),
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.purple,
          shape: const CircleBorder(
            side: BorderSide(color: AppColors.white, width: 5),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTab()),
            );
          },
          child: const ImageIcon(
            AssetImage(AppIcons.scanIcon),
            color: AppColors.white,
          ),
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.purple,
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(AppIcons.homeIcon)),
              label: 'Home',
              backgroundColor: AppColors.purple,
              activeIcon: ImageIcon(AssetImage(AppIcons.homeFilled)),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(AppIcons.addIcon)),
              label: 'Add',
              backgroundColor: AppColors.purple,
              activeIcon: ImageIcon(AssetImage(AppIcons.addFilled)),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(AppIcons.awareIcon)),
              label: 'Aware',
              backgroundColor: AppColors.purple,
              activeIcon: ImageIcon(AssetImage(AppIcons.awareFilled)),
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(AppIcons.menuIcon)),
              label: 'Menu',
              backgroundColor: AppColors.purple,
              activeIcon: ImageIcon(AssetImage(AppIcons.menuFilled)),
            ),
          ],
        ),
        body: tabs[currentIndex]);
  }

// FloatingActionButton buildFab() {
//   return FloatingActionButton(
//     onPressed: () {
//       Navigator.pushNamed(context, LoginScreen.routeName);
//     },
//     backgroundColor: AppColors.purple,
//     shape: const CircleBorder(
//         side: BorderSide(width: 5, color: AppColors.white)),
//     child: const Icon(
//       Icons.add,
//       color: AppColors.white,
//       size: 30,
//     ),
//   );
// }
}
