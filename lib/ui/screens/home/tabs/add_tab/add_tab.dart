import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
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
  State<AddTab> createState() => _AwareTabState();
}

class _AwareTabState extends State<AddTab> {
  late ThemeProvider themeProvider;
  String scannedBarcode = "Not scanned yet";
  String scannedText = "No text detected!";
  bool isScanning = false;
  File? _image;
  var barCode = TextEditingController();
  var productName = TextEditingController();
  var ingredients = TextEditingController();

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
      setState(() {
        scannedText = recognizedText.text.isNotEmpty
            ? recognizedText.text
            : "No text recognized!";
        ingredients.text = recognizedText.text;
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
                  Navigator.pop(context); // Close the modal
                  await pickImage(ImageSource.gallery); // Pick from gallery
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context); // Close the modal
                  await pickImage(ImageSource.camera); // Open camera
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
              "Product Name",
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
              "Ingredients",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
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
          ],
        ),
      ),
    );
  }
}
