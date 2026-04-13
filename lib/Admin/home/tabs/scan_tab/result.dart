import 'package:flutter/material.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/home/home.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatelessWidget {
  static const String routeName = "/resultScan";

  const ResultScreen({super.key});

  String getRiskImage(String? riskCategory) {
    switch (riskCategory) {
      case "A (High Risk)":
        return AppAssets.higiRisk;
      case "B (Moderate Risk)":
        return AppAssets.mediumHighRisk;
      case "C (Medium Risk)":
        return AppAssets.mediumRisk;
      case "D (Low Risk)":
        return AppAssets.lowMediumRisk;
      case "E (Minimal or No Risk)":
        return AppAssets.lowRisk;
      default:
        return AppAssets.lowRisk;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    print("Data received: $data");

    final String message = data['message'] ?? "Unknown result";
    final product = data['product'] ?? {};
    final String productName = product['productName'] ?? "Unknown product";
    final String barcode = product['barcode'] ?? "Unknown barcode";
    final List<dynamic> highRiskIngredients = data['highRiskIngredients'] ?? [];

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final String imageToShow = getRiskImage(
      highRiskIngredients.isNotEmpty
          ? highRiskIngredients[0]['riskCategory']
          : null,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: AppColors.Teal,
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
          children: [
            Text(
              "Risk rate",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Image.asset(
              imageToShow,
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
                color: AppColors.Teal,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              width: double.infinity,
              child: Text(
                "Product: $productName (Barcode: $barcode)",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 10),
            if (highRiskIngredients.isNotEmpty) ...[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Text(
                  "High-Risk Ingredients",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final ingredient = highRiskIngredients[index];
                    return ExpansionTile(
                      title: Text(
                        ingredient['ingredientName'] ?? '',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      children: [
                        if (ingredient['englishDescription'] != null)
                          ListTile(
                            title: Text("${ingredient['englishDescription']}"),
                          ),
                      ],
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
            ] else ...[
              const SizedBox(height: 20),
              Text(
                "No high-risk ingredients found.",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
            ],
            const SizedBox(height: 15),
            CustomButton(
              onClick: () {
                Navigator.pushNamed(context, HomeScreen.routeName);
              },
              title: "Done",
            ),
          ],
        ),
      ),
    );
  }
}
