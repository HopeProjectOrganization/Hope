import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognitionService {
  Future<String> recognizeText(File imageFile) async {
    final textRecognizer = TextRecognizer();
    final inputImage = InputImage.fromFile(imageFile);

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      final processedText = _postProcessText(recognizedText);
      textRecognizer.close();
      return processedText.isNotEmpty ? processedText : "No text recognized!";
    } catch (e) {
      return "Error recognizing text: $e";
    }
  }

  String _postProcessText(RecognizedText recognizedText) {
    List<TextBlock> blocks = recognizedText.blocks;

    blocks.sort((a, b) {
      if ((a.boundingBox.top - b.boundingBox.top).abs() < 10) {
        return a.boundingBox.left.compareTo(b.boundingBox.left);
      }
      return a.boundingBox.top.compareTo(b.boundingBox.top);
    });

    StringBuffer processedText = StringBuffer();
    bool foundIngredients = false;

    for (TextBlock block in blocks) {
      List<TextLine> lines = block.lines;
      lines.sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));

      for (TextLine line in lines) {
        String text = line.text.toLowerCase();

        if (text.contains("ingredients") && !foundIngredients) {
          foundIngredients = true;
          int index = text.indexOf("ingredients") + "ingredients".length;
          processedText.write(line.text.substring(index).trim() + " ");
          continue;
        }

        if (foundIngredients) {
          if (text.contains(".")) {
            processedText.write(text.substring(0, text.indexOf(".") + 1));
            return processedText.toString().trim();
          } else {
            processedText.write(line.text + " ");
          }
        }
      }
    }

    return foundIngredients
        ? processedText.toString().trim()
        : "Ingredients not found!";
  }
}
