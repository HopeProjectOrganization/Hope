import 'package:flutter/material.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/category_model.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';
import 'package:hope/ui/shared_widgets/utils/healthy_diet_category.dart';
import 'package:provider/provider.dart';

class HealthyDiet extends StatelessWidget {
  static const routeName = '/healthyDiet';

  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  HealthyDiet({super.key});

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    final List<CategoryModel> categories = [
      CategoryModel(
          image: AppAssets.recipes,
          id: appLocalizations.recipes,
          route: '/RECIPES'),
      CategoryModel(
          image: AppAssets.recommended,
          id: appLocalizations.veganRecipes,
          route: '/Vegan'),
      CategoryModel(
          image: AppAssets.exer1,
          id: appLocalizations.exercises,
          route: '/Exercises'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.healthyDiet),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined, color: AppColors.Teal),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Row(
                      children: [
                        Expanded(
                            child: HealthyDietCategory(
                                title: category.id,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    category.route,
                                    arguments: category.id,
                                  );
                                },
                                index: index,
                                image: category.image))
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: categories.length),
            )
          ],
        ),
      ),
    );
  }
}
