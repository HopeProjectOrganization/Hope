import 'package:flutter/material.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/chatbot/chat.dart';
import 'package:hope/ui/screens/home/home.dart';
import 'package:hope/ui/screens/home/tabs/home_tab/recently_scan.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/scanner.dart';
import 'package:hope/ui/shared_widgets/custom_home_button.dart';
import 'package:hope/ui/shared_widgets/float_button.dart';
import 'package:hope/ui/shared_widgets/utils/language_button.dart';
import 'package:hope/ui/shared_widgets/utils/theme_button.dart';

import 'recently_add.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String scannedBarcode = "Not scanned yet";

  @override
  void initState() {
    super.initState();
    barcodeScanner = BarcodeScannerService(context);
  }

  late BarcodeScannerService barcodeScanner;

  void startScan() {
    barcodeScanner.scanBarcode((result) {
      setState(() {
        scannedBarcode = result;
      });
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                child: Container(
                  width: double.infinity,
                  height: 118,
                  decoration: const BoxDecoration(
                    color: AppColors.Teal,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome Back ✨',
                                  style: TextStyle(color: AppColors.white),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Hope',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            ThemeButton(),
                            const SizedBox(width: 10),
                            LanguageButton(),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            CustomHomeButton(
                              image: AppAssets.awareButton,
                              onClick: () {
                                Navigator.pushNamed(
                                    context, HomeScreen.routeName,
                                    arguments: 2);
                              },
                            ),
                            CustomHomeButton(
                              image: AppAssets.scanButton,
                              onClick: () {
                                startScan();
                              },
                            ),
                            CustomHomeButton(
                              image: AppAssets.chatbotButton,
                              onClick: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen()),
                                );
                              },
                            ),
                            CustomHomeButton(
                              image: AppAssets.addButton,
                              onClick: () {
                                Navigator.pushNamed(
                                    context, HomeScreen.routeName,
                                    arguments: 1);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        RecentlyScan(),
                        const SizedBox(height: 16),
                        RecentlyAddedScreen(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatButton(),
          ),
        ],
      ),
    );
  }
}
