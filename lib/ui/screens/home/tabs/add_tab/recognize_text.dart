import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognitionService {
  Future<String> recognizeAndExtractInfo(File imageFile, bool isFood) async {
    final textRecognizer = TextRecognizer();
    final inputImage = InputImage.fromFile(imageFile);

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      textRecognizer.close();

      final processedText = _postProcessText(recognizedText);
      textRecognizer.close();

      final fullText = recognizedText.text;
      print("📄 النص الكامل:\n$fullText");
      print("📄 النص المعدل:\n$processedText");

      return isFood ? fullText : processedText;
    } catch (e) {
      print("❌ Error recognizing text: $e");
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

  Map<String, String> extractIngredientsWithValues(String text) {
    final List<String> basicIngredients = [
      'Water',
      'Sugar',
      'Citric Acid',
      'Natural Flavors',
      'Caffeine',
      'Carbonated Water',
      'Fruit Juice Concentrate',
      'Sodium Benzoate',
      'Aspartame',
      'Vitamin C',
      'Coloring (E150d)',
      'Guarana Extract',
      'L-Carnitine',
      'Taurine',
      'Tea Extract',
      'Energy',
      'Fat',
      'Protein',
      'Carbohydrate',
      'Calcium',
      'Phosphorus',
      'Vitamin A',
      'Vitamin B2',
      'Vitamin B12',
      'Vitamin D',
      'Vitamin E',
      'High Fructose Corn Syrup',
      'Sucralose',
      'Sodium',
      'Malic Acid',
      'Sorbitol',
      'Xylitol',
      'Stevia',
      'Acesulfame Potassium',
      'Potassium Sorbate',
      'Benzoic Acid',
      'Pectin',
      'Xanthan Gum',
      'Carrageenan',
      'Modified Corn Starch',
      'Milk Solids',
      'Whey Protein',
      'Soy Lecithin',
      'Palm Oil',
      'Cocoa',
      'Cream',
      'Skimmed Milk Powder',
      'Glucose Syrup',
      'Dextrose',
      'Green Tea Extract',
      'Inositol',
      'Niacin',
      'Pantothenic Acid (Vitamin B5)',
      'Folic Acid',
      'Magnesium',
      'Zinc',
    ];

    final unitCorrections = {
      'ma': 'mg',
      'mog': 'mg',
      'iu': 'IU',
      'Og': '0g',
      'og': '0g'
    };

    final regExp =
        RegExp(r'([\d.]+)\s?(mg|g|mcg|kcal|iu|%)', caseSensitive: false);
    final Map<String, String> result = {};

    final relevantText = text.contains("📊 النسب الغذائية:")
        ? text.split("📊 النسب الغذائية:")[1]
        : text;

    final lines = relevantText.split("\n");
    List<String> ingredients = [];
    int lastIngredientIndex = -1;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      for (final nutrient in basicIngredients) {
        if (line.toLowerCase().contains(nutrient.toLowerCase())) {
          ingredients.add(nutrient);
          lastIngredientIndex = i;
        }
      }
    }

    List<String> values = [];
    for (int i = lastIngredientIndex + 1; i < lines.length; i++) {
      String line = lines[i];
      line = line.replaceAllMapped(
          RegExp(r'(\d)9\b'), (match) => '${match.group(1)}g');

      final matches = regExp.firstMatch(line);
      if (matches != null) {
        String number = matches.group(1) ?? '';
        String unit = matches.group(2) ?? '';
        String value = '$number $unit';

        if (line.contains(RegExp(r'Vitamin [A-Za-z]'))) continue;

        unitCorrections.forEach((wrongUnit, correctUnit) {
          if (value.contains(wrongUnit)) {
            value = value.replaceAll(wrongUnit, correctUnit);
          }
        });

        values.add(value.trim());
      }
    }

    for (final nutrient in ingredients) {
      if (!result.containsKey(nutrient)) {
        result[nutrient] = '..';
      }
    }

    for (int i = 0; i < ingredients.length && i < values.length; i++) {
      result[ingredients[i]] = values[i];
    }

    return result;
  }

  void displayResults(String text) {
    final results = extractIngredientsWithValues(text);

    print("📊 النسب الغذائية:");
    results.forEach((key, value) {
      print("$key: $value");
    });
  }
}

// import 'dart:io';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
//
// class TextRecognitionService {
//   Future<String> recognizeAndExtractInfo(File imageFile) async {
//     final textRecognizer = TextRecognizer();
//     final inputImage = InputImage.fromFile(imageFile);
//
//     try {
//       final RecognizedText recognizedText =
//       await textRecognizer.processImage(inputImage);
//       textRecognizer.close();
//
//       final fullText = recognizedText.text;
//       print("📄 النص الكامل:\n$fullText");
//
//       return fullText;
//     } catch (e) {
//       print("❌ Error recognizing text: $e");
//       return "Error recognizing text: $e";
//     }
//   }
//
//   Map<String, String> extractIngredientsWithValues(String text) {
//     final Map<String, String> result = {};
//
//     final nutrientKeywords = [
//       'Energy', 'Fat', 'Protein', 'Carbohydrate', 'Calcium', 'Phosphorus',
//       'Vitamin A', 'Vitamin B2', 'Vitamin B12', 'Vitamin D'
//     ];
//
//     final unitCorrections = {
//       'ma': 'mg',
//       'mog': 'mg',
//       'iu': 'IU',
//     };
//
//     // نبحث عن كل سطر يحتوي على عنصر + قيمة
//     final lines = text.split('\n');
//     final regExp = RegExp(r'^(.*?)(\d+\.?\d*)\s*(kcal|mg|g|mcg|iu|IU)?$', caseSensitive: false);
//
//     for (final line in lines) {
//       final match = regExp.firstMatch(line.trim());
//       if (match != null) {
//         final name = match.group(1)?.trim() ?? '';
//         final value = match.group(2) ?? '';
//         String unit = match.group(3) ?? '';
//
//         // تصحيح الوحدات لو فيها أخطاء
//         unitCorrections.forEach((wrong, correct) {
//           unit = unit.toLowerCase().replaceAll(wrong, correct.toLowerCase());
//         });
//
//         for (final keyword in nutrientKeywords) {
//           if (name.toLowerCase().contains(keyword.toLowerCase())) {
//             result[keyword] = "$value ${unit.toUpperCase()}".trim();
//             break;
//           }
//         }
//       }
//     }
//
//     return result;
//   }
//
// }
