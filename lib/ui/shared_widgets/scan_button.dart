import 'package:flutter/material.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/scanner.dart';
import 'package:provider/provider.dart';

class ScanButton extends StatefulWidget {
  const ScanButton({super.key});

  @override
  State<ScanButton> createState() => _ScanButtonState();
}

class _ScanButtonState extends State<ScanButton> {
  late ThemeProvider themeProvider;

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
    return FloatingActionButton(
      backgroundColor: AppColors.purple,
      shape: CircleBorder(
        side: BorderSide(color: AppColors.white, width: 5),
      ),
      onPressed: () {
        // Navigator.pushNamed(
        //   context,
        //   ScanTab.routeName,
        // );
        startScan();
      },
      child: ImageIcon(
        const AssetImage(AppIcons.scanIcon),
        color: color,
      ),
    );
  }
}
