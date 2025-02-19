import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/home/tabs/add_tab/add_tab.dart';
import 'package:hope/ui/screens/home/tabs/aware_tab/aware_tab.dart';
import 'package:hope/ui/screens/home/tabs/home_tab/home_tab.dart';
import 'package:hope/ui/screens/home/tabs/menu_tab//menu_tab.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/result.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  List<Widget> tabs = [
    const HomeTab(),
    const AddTab(),
    AwareTab(),
    const MenuTab(),
  ];
  int currentIndex = 0;
  String scannedBarcode = "Not Scanned yet";

  Future<void> scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
          "#ff8E56FF",
          "Cancel",
          true,
          ScanMode.BARCODE,
          500,
          "back",
          ScanFormat.ONLY_BARCODE);

      if (!mounted) return;

      setState(() {
        scannedBarcode = barcode != "-1" ? barcode : "Scan canceled";
      });
      if (scannedBarcode != "-1" && scannedBarcode.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Result(
              barcode: scannedBarcode,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        scannedBarcode = "Error occurred during scanning!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);

    Color color = themeProvider.isDark() ? AppColors.dark : AppColors.white;

    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    final keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: keyboardIsOpen
                ? null
                : FloatingActionButton(
                    backgroundColor: AppColors.purple,
                    shape: CircleBorder(
                      side: BorderSide(color: color, width: 5),
                    ),
                    onPressed: scanBarcode,
                    child: ImageIcon(
                      AssetImage(AppIcons.scanIcon),
                      color: color,
                    ),
                  ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(AppIcons.homeIcon),
                    color: color,
                  ),
                  label: appLocalizations.home,
                  activeIcon:
                      ImageIcon(AssetImage(AppIcons.homeFilled), color: color),
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage(AppIcons.addIcon), color: color),
                  label: appLocalizations.add,
                  activeIcon:
                      ImageIcon(AssetImage(AppIcons.addFilled), color: color),
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage(AppIcons.awareIcon), color: color),
                  label: appLocalizations.aware,
                  activeIcon:
                      ImageIcon(AssetImage(AppIcons.awareFilled), color: color),
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage(AppIcons.menuIcon), color: color),
                  label: appLocalizations.menu,
                  activeIcon:
                      ImageIcon(AssetImage(AppIcons.menuFilled), color: color),
                ),
          ],
        ),
            body: tabs[currentIndex]));
  }

}