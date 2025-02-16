import 'package:flutter/material.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/core/theme/app_theme.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:hope/ui/shared_widgets/custom_label.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';
import 'package:hope/ui/shared_widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';

class AddTab extends StatefulWidget {
  const AddTab({super.key});

  // late AppLocalizations appLocalizations;

  @override
  State<AddTab> createState() => _AwareTabState();
}

class _AwareTabState extends State<AddTab> {
  late ThemeProvider themeProvider;
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
          ScanFormat.ONLY_BARCODE);

      if (!mounted) return;

      setState(() {
        scannedBarcode = barcode != "-1" ? barcode : "Scan canceled";
      });

      setState(() {
        scannedBarcode = barcode != "-1" ? barcode : "Cancel";
        barCode.text = scannedBarcode;
      });
    } catch (e) {
      setState(() {
        scannedBarcode = "Error occurred during scanning!";
      });
    }
  }

  var barCode = TextEditingController();
  var productName = TextEditingController();
  var ingredients = TextEditingController();
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return CustomScaffold(
        title: 'Add Product',
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Barcode",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              SizedBox(
                height: 8,
              ),
              CustomLabel(
                controller: barCode,
                hint: null,
                prefixIcon: null,
                suffixIcon: IconButton(
                  icon: const ImageIcon(AssetImage(AppIcons.barCodeIcon)),
                  onPressed: scanBarcode,
                  color: AppColors.gray,
                  iconSize: 60,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Product Name",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              SizedBox(
                height: 8,
              ),
              CustomTextField(controller: productName, hint: ""),
              SizedBox(
                height: 16,
              ),
              Text(
                "Ingredients",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              SizedBox(
                height: 8,
              ),
              CustomTextField(
                controller: ingredients,
                hint: "",
                minLines: 6,
                suffixIcon: IconButton(
                  icon: const ImageIcon(
                    AssetImage(AppIcons.camera),
                  ),
                  onPressed: scanBarcode,
                  color: AppColors.gray,
                  iconSize: 40,
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ));
  }
}
