import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  String? scannedBarcode;
  final ScanService _scanService = ScanService();

  Future<void> scanBarcode() async {
    showLoading(context);

    var result = await _scanService.scanBarcode(context);

    if (!mounted) return;

    hideLoading(context);

    if (result != null) {
      setState(() {
        scannedBarcode =
            result['message'] ?? AppLocalizations.of(context)!.noMessage;
      });

      Navigator.pushNamed(
        context,
        ResultScreen.routeName,
        arguments: result,
      );
    } else {
      setState(() {
        scannedBarcode = null;
      });

      showMessage(
        context,
        AppLocalizations.of(context)!.noScanResult,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.barcodeScanner),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: AppColors.Teal,
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
              scannedBarcode == null
                  ? appLocalizations.noScanYet
                  : "${appLocalizations.scanResult}: $scannedBarcode",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanBarcode,
              child: Text(appLocalizations.startScanning),
            ),
          ],
        ),
      ),
    );
  }
}
