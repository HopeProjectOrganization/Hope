import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

class ResultScreen extends StatelessWidget {
  final String barcode;

  static const String routeName = "/resultScan";

  const ResultScreen({required this.barcode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: AppColors.purple,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text(
          'Scanned Barcode: $barcode',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
