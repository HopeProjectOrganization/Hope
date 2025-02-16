import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final String barcode;

  Result({required this.barcode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scanned Barcode')),
      body: Center(
        child: Text(
          'Scanned Barcode: $barcode',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
