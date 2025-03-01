import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/home/tabs/add_tab/add_tab.dart';
import 'package:hope/ui/screens/home/tabs/aware_tab/aware_tab.dart';
import 'package:hope/ui/screens/home/tabs/home_tab/home_tab.dart';
import 'package:hope/ui/screens/home/tabs/menu_tab//menu_tab.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/scan_tab.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final indexArg = ModalRoute.of(context)
        ?.settings
        .arguments;

    if (indexArg != null && indexArg is int) {
      currentIndex = indexArg;
    } else {
      currentIndex = currentIndex;
    }
  }

  List<Widget> tabs = [
    const HomeTab(),
    const AddTab(),
    AwareTab(),
    MenuTab(),
  ];

  String scannedBarcode = "Not Scanned yet";

  // Future<void> scanBarcode() async {
  //   try {
  //     String barcode = await FlutterBarcodeScanner.scanBarcode(
  //         "#ff8E56FF",
  //         "Cancel",
  //         true,
  //         ScanMode.BARCODE,
  //         500,
  //         "back",
  //         ScanFormat.ONLY_BARCODE);
  //
  //     if (!mounted) return;
  //
  //     setState(() {
  //       scannedBarcode = barcode != "-1" ? barcode : "Scan canceled";
  //     });
  //     if (scannedBarcode != "-1" && scannedBarcode.isNotEmpty) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => Result(
  //             barcode: scannedBarcode,
  //           ),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     setState(() {
  //       scannedBarcode = "Error occurred during scanning!";
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);

    Color color = themeProvider.isDark() ? AppColors.dark : AppColors.white;

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
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ScanTab.routeName,
                    );
                  },
                  child: ImageIcon(
                      AssetImage(AppIcons.scanIcon),
                      color: color,
                    ),
                  ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                setState(() {
              currentIndex = index;
              });
          },
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(AppIcons.homeIcon),
                  ),
                  label: appLocalizations.home,
                  activeIcon: ImageIcon(
                    AssetImage(AppIcons.homeFilled),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(AppIcons.addIcon),
                  ),
                  label: appLocalizations.add,
                  activeIcon: ImageIcon(
                    AssetImage(AppIcons.addFilled),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(AppIcons.awareIcon),
                  ),
                  label: appLocalizations.aware,
                  activeIcon: ImageIcon(
                    AssetImage(AppIcons.awareFilled),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(AppIcons.menuIcon),
                  ),
                  label: appLocalizations.menu,
                  activeIcon: ImageIcon(
                    AssetImage(AppIcons.menuFilled),
                  ),
                ),
          ],
        ),
          body: IndexedStack(
            index: currentIndex,
            children: tabs,
          ),
          // tabs[currentIndex]));
        ));
  }

}