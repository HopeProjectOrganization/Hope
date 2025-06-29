import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/home/home.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';

class ResultScreen extends StatelessWidget {
  static const String routeName = "/result-screen";

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
    final product = data['product'] ?? {};
    final List<dynamic> highRiskIngredients = data['highRiskIngredients'] ?? [];

    final String productName = product['productName'] ?? "Unknown product";
    final String barcode = product['barcode'] ?? "Unknown barcode";
    final String imageToShow = getRiskImage(
      highRiskIngredients.isNotEmpty
          ? highRiskIngredients[0]['riskCategory']
          : null,
    );

    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.result),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined, color: AppColors.Teal),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔸 Risk image
            Card(
              elevation: 4,
              color: AppColors.cloudi,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      appLocalizations.riskRate,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Image.asset(
                      imageToShow,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.18,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 🔸 Product info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.Teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.Teal, width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.qr_code, color: AppColors.yellow),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${appLocalizations.productName}: $productName\n${appLocalizations.barcode}: $barcode',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: AppColors.Teal),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (highRiskIngredients.isNotEmpty) ...[
              Text(
                appLocalizations.highRiskIngredients,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
            ],

            // 🔸 Ingredient list or message if empty
            Expanded(
              child: highRiskIngredients.isNotEmpty
                  ? ListView.separated(
                      itemCount: highRiskIngredients.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final ingredient = highRiskIngredients[index];
                        return Card(
                          elevation: 4,
                          color: AppColors.cloudi,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ingredient['ingredientName'] ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                if (ingredient['englishDescription'] != null)
                                  Text(
                                    ingredient['englishDescription'],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.verified_outlined,
                              size: 60, color: AppColors.Teal),
                          const SizedBox(height: 12),
                          Text(
                            appLocalizations.noHighRiskIngredientsFound,
                            style: Theme.of(context).textTheme.labelLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: 20),
            CustomButton(
              onClick: () => Navigator.pushNamedAndRemoveUntil(
                context,
                HomeScreen.routeName,
                (route) => false,
              ),
              title: appLocalizations.done,
            ),
          ],
        ),
      ),
    );
  }
}
