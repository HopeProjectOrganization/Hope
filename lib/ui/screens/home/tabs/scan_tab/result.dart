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
    final barcode = ModalRoute.of(context)?.settings.arguments as String? ??
        "Unknown"; // ✅ تأمين القيم الافتراضية

    Map<String, String> ingredients = {
      "Carbonated Water": "89%",
      "Sugar": "11%",
      "Sodium": "1%",
      "Caramel Color": "0.1%",
      "Caffeine": "0.1%",
      "Phosphoric Acid": "0.01%", // تم تصحيح الخطأ في "Aci" إلى "Acid"
    };

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

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
        body: Padding(
          padding: EdgeInsets.all(16),
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
              SizedBox(
                height: 15,
              ),
              Text(
                "You should eat from this product not more than 3 times per week",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: AppColors.purple,
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                width: double.infinity,
                child: Text(
                  "Ingredients",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        String ingredient = ingredients.keys.elementAt(index);
                        String percentage = ingredients.values.elementAt(index);
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(ingredient,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ),
                              Text(percentage,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(
                            color: Colors.grey, // اللون الرمادي
                            thickness: 1, // سمك الخط
                            height: 10, // المسافة بين العناصر
                          ),
                      itemCount: ingredients.length)),
              SizedBox(
                height: 15,
              ),
              CustomButton(onClick: () {}, title: "Done"),
            ],
          ),
        )
        // Center(
        //   child: Text(
        //     'Scanned Barcode: $barcode',
        //     style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //   ),
        // ),
        );
  }
}
