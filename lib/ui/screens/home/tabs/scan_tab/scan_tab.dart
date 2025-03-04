import 'package:flutter/material.dart';
import 'package:hope/Api/scan_service.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/scan_service.dart';

class ScanTab extends StatefulWidget {
  const ScanTab({super.key});

  static const String routeName = "/ScanTabScreen";

  @override
  _ScanTabState createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  String scannedBarcode = "Not scanned yet";
  final ScanService _scanService = ScanService();

  late BarcodeScannerService barcodeScanner;

  @override
  void initState() {
    super.initState();
    barcodeScanner = BarcodeScannerService(context);
  }

  void startScan() {
    barcodeScanner.scanBarcode((result) {
      setState(() {
        scannedBarcode = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barcode Scanner"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: AppColors.purple,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Result: $scannedBarcode",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: startScan,
              child: const Text("Start Scanning"),
            ),
          ],
        ),
      ),
    );
  }
}
