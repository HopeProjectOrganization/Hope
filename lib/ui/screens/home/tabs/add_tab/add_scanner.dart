import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/home/tabs/add_tab/add_tab.dart';
import 'package:image_picker/image_picker.dart';

class AddScanner extends StatefulWidget {
  static const routeName = '/addScanner';

  @override
  _AddScannerState createState() => _AddScannerState();
}

class _AddScannerState extends State<AddScanner> {
  String scannedText = "No text detected!";
  bool isScanning = false;
  File? _image;

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTab(),
            ));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Text Scanner")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_image != null) Image.file(_image!, height: 200),
              const SizedBox(height: 20),
              Text(
                scannedText,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => pickImage(ImageSource.camera),
                child: const Text("Scan from Camera"),
              ),
              ElevatedButton(
                onPressed: () => pickImage(ImageSource.gallery),
                child: const Text("Select from Gallery"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
