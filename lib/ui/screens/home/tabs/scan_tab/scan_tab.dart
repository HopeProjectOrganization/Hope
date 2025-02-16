import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ScanTab extends StatefulWidget {
  const ScanTab({super.key});

  static const String routeName = "/ScanTabScreen";

  @override
  State<ScanTab> createState() => ScanTabState();
}

class ScanTabState extends State<ScanTab> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BarcodeScannerScreen(),
    );
  }
}

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  BarcodeScannerScreenState createState() => BarcodeScannerScreenState();
}

class BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  String scannedBarcode = "Not scanned yet";

  Future<void> scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
          "#ff8E56FF",
          "Cancel",
          true,
          ScanMode.BARCODE,
          500,
          "back",
          ScanFormat.ALL_FORMATS);

      if (!mounted) return;

      setState(() {
        scannedBarcode = barcode != "-1" ? barcode : "Scan canceled";
      });
    } catch (e) {
      setState(() {
        scannedBarcode = "Error occurred during scanning!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Barcode Scanner")),
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
              onPressed: scanBarcode,
              child: const Text("Start Scanning"),
            ),
          ],
        ),
      ),
    );
  }
}
