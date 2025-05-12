import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/home/tabs/add_tab/add_tab.dart';
import 'package:hope/ui/screens/home/tabs/aware_tab/aware_tab.dart';
import 'package:hope/ui/screens/home/tabs/home_tab/home_tab.dart';
import 'package:hope/ui/screens/home/tabs/menu_tab/menu_tab.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/scanner.dart';
import 'package:hope/ui/shared_widgets/float_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  const HomeScreen({super.key});

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
    barcodeScanner = BarcodeScannerService(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final indexArg = ModalRoute.of(context)
        ?.settings
        .arguments;

    if (indexArg != null &&
        indexArg is int &&
        indexArg >= 0 &&
        indexArg < tabs.length) {
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


  late BarcodeScannerService barcodeScanner;

  void startScan() {
    barcodeScanner.scanBarcode((result) {
      setState(() {
        scannedBarcode = result;
      });
    });
  }

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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: keyboardIsOpen
              ? null
              : Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.04),
                        child: FloatingActionButton(
                          heroTag: 'scan-main-button',
                          backgroundColor: AppColors.purple,
                          shape: CircleBorder(
                            side: BorderSide(color: AppColors.white, width: 5),
                          ),
                          onPressed: () {
                            startScan();
                          },
                          child: ImageIcon(
                            const AssetImage(AppIcons.scanIcon),
                            color: color,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.1,
                      right: MediaQuery.of(context).size.width * 0.05,
                      child: FloatButton(),
                    ),
                  ],
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
                icon: const ImageIcon(
                  AssetImage(AppIcons.homeIcon),
                ),
                label: appLocalizations.home,
                activeIcon: const ImageIcon(
                  AssetImage(AppIcons.homeFilled),
                ),
              ),
              BottomNavigationBarItem(
                icon: const ImageIcon(
                  AssetImage(AppIcons.addIcon),
                ),
                label: appLocalizations.add,
                activeIcon: const ImageIcon(
                  AssetImage(AppIcons.addFilled),
                ),
              ),
              BottomNavigationBarItem(
                icon: const ImageIcon(
                  AssetImage(AppIcons.awareIcon),
                ),
                label: appLocalizations.aware,
                activeIcon: const ImageIcon(
                  AssetImage(AppIcons.awareFilled),
                ),
              ),
              BottomNavigationBarItem(
                icon: const ImageIcon(
                  AssetImage(AppIcons.menuIcon),
                ),
                label: appLocalizations.menu,
                activeIcon: const ImageIcon(
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