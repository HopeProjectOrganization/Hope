import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/result.dart';

class CustomRecentlyCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final String barcode;
  final List<dynamic> highRiskIngredients;

  const CustomRecentlyCard({
    required this.product,
    required this.barcode,
    required this.highRiskIngredients,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          color: AppColors.lavender,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                product['productName'],
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Spacer(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        ResultScreen.routeName,
                        arguments: {
                          'message': "Product successfully added!",
                          'product': {
                            'productName': product['productName'],
                            'barcode': barcode,
                          },
                          'highRiskIngredients': highRiskIngredients,
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Text("See result",
                            style: Theme.of(context).textTheme.bodyLarge),
                        Icon(Icons.arrow_forward_ios_rounded,
                            color: AppColors.dark),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
