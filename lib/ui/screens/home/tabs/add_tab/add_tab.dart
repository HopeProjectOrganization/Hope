import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/add/add_service.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/home/tabs/add_tab/image_picker.dart';
import 'package:hope/ui/screens/home/tabs/add_tab/recognize_text.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/scanner.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:hope/ui/shared_widgets/custom_label.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';
import 'package:hope/ui/shared_widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class AddTab extends StatefulWidget {
  static const routeName = '/addTab';
  const AddTab({super.key});

  @override
  AddTabState createState() => AddTabState();
}

class AddTabState extends State<AddTab> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;
  late BarcodeScannerService barcodeScanner;

  String scannedBarcode = "Not scanned yet";
  String scannedText = "No text detected!";
  bool isScanning = false;
  File? _image;
  var barCode = TextEditingController();
  var productName = TextEditingController();
  var ingredients = TextEditingController();
  final AddService _addService = AddService();

  final ImagePickerService imagePickerService = ImagePickerService();

  TextRecognitionService textRecognitionService = TextRecognitionService();

  Future<void> processImage(File imageFile) async {
    String extractedText =
        await textRecognitionService.recognizeText(imageFile);

    setState(() {
      scannedText = extractedText;
      ingredients.text = extractedText;
      isScanning = false;
    });
  }

  void _showImageSourceActionSheet(BuildContext context) {
    imagePickerService.showImageSourceActionSheet(context, (File image) {
      setState(() {
        _image = image;
        isScanning = true;
      });
      processImage(_image!);
    });
  }

  Future<void> addProduct() async {
    await AddService.addProduct(
      context,
      productName.text,
      barCode.text,
      ingredients.text,
    );
  }

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
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;
    return CustomScaffold(
        title: appLocalizations.addProduct,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appLocalizations.barcode,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomLabel(
                  controller: barCode,
                  hint: null,
                  prefixIcon: null,
                  suffixIcon: IconButton(
                    icon: const ImageIcon(AssetImage(AppIcons.barCodeIcon)),
                    onPressed: startScan,
                    color: AppColors.gray,
                    iconSize: 60,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  appLocalizations.productName,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextField(controller: productName, hint: ""),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  appLocalizations.ingredients,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(
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
                    onPressed: () async {
                      _showImageSourceActionSheet(context);
                    },
                    color: AppColors.gray,
                    iconSize: 40,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomButton(
                      title: 'Add Product',
                      onClick: () async {
                        await addProduct();
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ));
  }
}