import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hope/Api/add_service.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:hope/ui/shared_widgets/custom_label.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';
import 'package:hope/ui/shared_widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';

class AddTab extends StatefulWidget {
  static const routeName = '/addTab';
  const AddTab({super.key});

  @override
  State<AddTab> createState() => _AddTab();
}

class _AddTab extends State<AddTab> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  String scannedBarcode = "Not scanned yet";
  String scannedText = "No text detected!";
  bool isScanning = false;
  File? _image;
  var barCode = TextEditingController();
  var productName = TextEditingController();
  var ingredients = TextEditingController();
  final AddService _addService = AddService();

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
        barCode.text = scannedBarcode;
      });
    } catch (e) {
      setState(() {
        scannedBarcode = "Error occurred during scanning!";
      });
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        isScanning = true;
      });

      await recognizeText(_image!);
    }
  }

  Future<void> recognizeText(File imageFile) async {
    final textRecognizer = TextRecognizer();
    final inputImage = InputImage.fromFile(imageFile);

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      final processedText = postProcessText(recognizedText);

      setState(() {
        scannedText =
            processedText.isNotEmpty ? processedText : "No text recognized!";
        ingredients.text = processedText;
        isScanning = false;
      });
      textRecognizer.close();
    } catch (e) {
      setState(() {
        scannedText = "Error recognizing text: $e";
        isScanning = false;
      });
    }
  }

  String postProcessText(RecognizedText recognizedText) {
    List<TextBlock> blocks = recognizedText.blocks;

    blocks.sort((a, b) {
      if ((a.boundingBox.top - b.boundingBox.top).abs() < 10) {
        return a.boundingBox.left.compareTo(b.boundingBox.left);
      }
      return a.boundingBox.top.compareTo(b.boundingBox.top);
    });

    StringBuffer processedText = StringBuffer();

    for (TextBlock block in blocks) {
      List<TextLine> lines = block.lines;
      lines.sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));

      for (TextLine line in lines) {
        processedText.write(line.text);
        processedText.write(" ");
      }
      processedText.write("\n");
    }

    return processedText.toString();
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  await pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> addProduct() async {
    await _addService.addProduct(
      context,
      productName.text,
      barCode.text,
      ingredients.text,
    );
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
                onPressed: scanBarcode,
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
                Container(
                  child: CustomTextField(
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
