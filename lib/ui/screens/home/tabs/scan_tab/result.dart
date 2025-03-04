import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatelessWidget {
  static const String routeName = "/resultScan";

  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};

    final String message = data['message'] ?? "Unknown result";
    final product = data['product'] ?? {};
    final String productName = product['productName'] ?? "Unknown product";
    final String barcode = product['barcode'] ?? "Unknown barcode";
    final highRiskIngredients = data['highRiskIngredients'] ?? null;

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Risk rate",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Image.asset(
              AppAssets.result,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            const SizedBox(height: 15),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: const BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              width: double.infinity,
              child: Text(
                "Product: $productName (Barcode: $barcode)",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 10),
            if (highRiskIngredients != null) ...[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: Text(
                  "High-Risk Ingredients",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
            ] else ...[
              Text(
                "No high-risk ingredients found.",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 15),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final ingredient = highRiskIngredients[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            ingredient['ingredientName'],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 10,
                ),
                itemCount: highRiskIngredients.length,
              ),
            ),
            const SizedBox(height: 15),
            CustomButton(onClick: () {}, title: "Done"),
          ],
        ),
      ),
    );
  }
}
