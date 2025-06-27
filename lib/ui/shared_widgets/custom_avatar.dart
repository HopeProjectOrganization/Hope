import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  final String imageAsset;
  final double radius;

  const CustomAvatar({
    Key? key,
    required this.imageAsset,
    this.radius = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: AssetImage(imageAsset),
    );
  }
}
