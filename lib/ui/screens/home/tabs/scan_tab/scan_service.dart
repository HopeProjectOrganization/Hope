import 'package:flutter/material.dart';
import 'package:hope/Api/scan/scan_service.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/result.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';

class BarcodeScannerService {
  final BuildContext context;

  final ScanService _scanService = ScanService();

  BarcodeScannerService(this.context);

  Future<void> scanBarcode(Function(String) onResult) async {
    showLoading(context);

    var result = await _scanService.scanBarcode();

    if (!context.mounted) return;

    hideLoading(context);

    if (result != null) {
      onResult(result['message'] ?? "No message");

      Navigator.pushNamed(
        context,
        ResultScreen.routeName,
        arguments: result,
      );
    } else {
      onResult("Error: No result from scanning");
    }
  }
}
