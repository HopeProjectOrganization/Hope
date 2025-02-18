import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final String barcode;

  const Result({required this.barcode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanned Barcode')),
      body: Center(
        child: Text(
          'Scanned Barcode: $barcode',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
