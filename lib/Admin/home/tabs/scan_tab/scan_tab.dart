import 'package:flutter/material.dart';
import 'package:hope/Api/scan/scan_service.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/result.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';

class ScanTab extends StatefulWidget {
  const ScanTab({super.key});

  static const String routeName = "/ScanTabScreen";

  @override
  _ScanTabState createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  String scannedBarcode = "Not scanned yet";
  final ScanService _scanService = ScanService();

  Future<void> scanBarcode() async {
    showLoading(context);

    // Call the ScanService to perform scanning and fetch the API result
    var result = await _scanService.scanBarcode(context);

    if (!mounted) return;

    hideLoading(context);

    if (result != null) {
      setState(() {
        scannedBarcode = result['message'] ?? "No message";
      });

      Navigator.pushNamed(
        context,
        ResultScreen.routeName,
        arguments: result, // Pass the entire result data to the next screen
      );
    } else {
      setState(() {
        scannedBarcode = "Error: No result from scanning";
      });
    }
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
              onPressed: scanBarcode,
              child: const Text("Start Scanning"),
            ),
          ],
        ),
      ),
    );
  }
}
