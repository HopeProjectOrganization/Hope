import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/Api/add/add_service.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/home/tabs/add_tab/image_picker.dart';
import 'package:hope/ui/screens/home/tabs/add_tab/recognize_text.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/scanner.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:hope/ui/shared_widgets/custom_drop_down.dart';
import 'package:hope/ui/shared_widgets/custom_label.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';
import 'package:hope/ui/shared_widgets/custom_text_field.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class AddTab extends StatefulWidget {
  static const routeName = '/addTab';
  const AddTab({super.key});

  @override
  AddTabState createState() => AddTabState();
}

class AddTabState extends State<AddTab> {
  String? selectedType;

  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;
  late BarcodeScannerService barcodeScanner;

  String scannedBarcode = "";
  String scannedText = "";
  bool isScanning = false;
  File? _image;
  var barCode = TextEditingController();
  var productName = TextEditingController();
  var ingredients = TextEditingController();
  bool isFood = false;

  final ImagePickerService imagePickerService = ImagePickerService();
  TextRecognitionService textRecognitionService = TextRecognitionService();

  Future<void> processImage(File imageFile) async {
    final extractedText =
        await textRecognitionService.recognizeAndExtractInfo(imageFile, isFood);
    final extractedValues =
        textRecognitionService.extractIngredientsWithValues(extractedText);

    final buffer = StringBuffer();

    if (isFood) {
      if (extractedValues.isNotEmpty) {
        buffer.writeln(extractedText);
      } else {
        buffer.writeln(appLocalizations.noNutrientFound);
      }
    }

    setState(() {
      scannedText = extractedText;
      ingredients.text = isFood ? buffer.toString() : extractedText;
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
    if (productName.text.isEmpty ||
        barCode.text.isEmpty ||
        ingredients.text.isEmpty) {
      return;
    }

    try {
      if (isFood) {
        await AddService.addProduct(
          context,
          productName.text,
          barCode.text,
          ingredients.text,
          "Food",
          scannedText,
        );
      } else {
        await AddService.addProduct(
          context,
          productName.text,
          barCode.text,
          ingredients.text,
          selectedType ?? "Beauty",
        );
      }
      showMessage(context, appLocalizations.productAddedSuccessfully,
          type: MessageType.success);
    } catch (e) {
      showMessage(context, appLocalizations.errorOccurred,
          type: MessageType.error);
    }
  }

  Future<void> scanBarcode(BuildContext context) async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff8E56FF",
        appLocalizations.cancel,
        true,
        ScanMode.BARCODE,
        500,
        "back",
        ScanFormat.ONLY_BARCODE,
      );

      if (barcode != "-1") {
        setState(() {
          scannedBarcode = barcode;
          barCode.text = barcode;
        });
      } else {
        showMessage(context, appLocalizations.scanCancelled,
            type: MessageType.warning);
      }
    } catch (e) {
      showMessage(context, appLocalizations.scanningError,
          type: MessageType.error);
    }
  }

  @override
  void initState() {
    super.initState();
    barcodeScanner = BarcodeScannerService(context);
  }

  void startScan() {
    scanBarcode(context);
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
              Text(appLocalizations.chooseTheProductType,
                  style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              CustomDropDown(
                items: [appLocalizations.beauty, appLocalizations.food],
                labelText: appLocalizations.chooseTheProductType,
                initialValue: selectedType,
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                    isFood = value == appLocalizations.food;
                  });
                },
              ),
              const SizedBox(height: 8),
              Text(appLocalizations.barcode,
                  style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
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
              const SizedBox(height: 16),
              Text(appLocalizations.productName,
                  style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              CustomTextField(controller: productName, hint: ""),
              const SizedBox(height: 16),
              Text(appLocalizations.ingredients,
                  style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              CustomTextField(
                controller: ingredients,
                hint: "",
                minLines: 6,
                suffixIcon: IconButton(
                  icon: const ImageIcon(AssetImage(AppIcons.camera)),
                  onPressed: () async {
                    _showImageSourceActionSheet(context);
                  },
                  color: AppColors.gray,
                  iconSize: 40,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomButton(
                    title: appLocalizations.add,
                    onClick: () async {
                      await addProduct();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

Map<String, String> parseTextToNutrientMap(String input) {
  final lines = input
      .split('\n')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
  final result = <String, String>{};
  final mid = (lines.length / 2).floor();
  final keys = lines.sublist(0, mid);
  final values = lines.sublist(mid);

  for (int i = 0; i < keys.length && i < values.length; i++) {
    final numberOnly = _extractNumberAsString(values[i]);
    if (numberOnly != null) {
      result[keys[i]] = numberOnly;
    }
  }

  return result;
}

String? _extractNumberAsString(String text) {
  final match = RegExp(r'[\d.]+').firstMatch(text);
  return match?.group(0);
}
