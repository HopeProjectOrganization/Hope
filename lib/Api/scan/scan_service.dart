import 'dart:convert';

import 'package:hope/ui/screens/home/tabs/home_tab/utls/recent_scan_provider.dart';
import 'package:http/http.dart' as http;
import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ScanService {
  Future<Map<String, dynamic>?> scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff8E56FF",
        "Cancel",
        true,
        ScanMode.BARCODE,
        500,
        "back",
        ScanFormat.ONLY_BARCODE,
      );

      if (barcode == "-1") {
        return {'message': 'Scan canceled'};
      }

      var url = Uri.parse("http://192.168.1.109:9090/api/scan/$barcode");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as Map<String, dynamic>;

        final recentScannedProvider = RecentScannedProductsProvider();
        await recentScannedProvider.addScannedProduct(data['productName']);

        await recentScannedProvider.refreshRecentScannedProducts();

        String? lastScanned =
            await recentScannedProvider.getLastScannedProduct();
        print("آخر منتج تم مسحه: $lastScanned");

        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return {'message': 'Failed to fetch data from the server'};
      }
    } catch (e) {
      return {'message': 'Error occurred during scanning: $e'};
    }
  }
}
