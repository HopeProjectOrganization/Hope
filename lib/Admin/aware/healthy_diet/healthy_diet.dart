import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/model/category_model.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';
import 'package:hope/ui/shared_widgets/utils/healthy_diet_category.dart';
import 'package:provider/provider.dart';

class AdminHealthyDiet extends StatelessWidget {
  static const routeName = '/healthyDiet';

  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  AdminHealthyDiet({super.key});

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

    return CustomScaffold(
      title: appLocalizations.healthyDiet,
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
      actions: [
        IconButton(
          icon: const Icon(Icons.search_outlined),
          onPressed: () {
            // Add search functionality here
          },
        ),
      ],
    );
  }
}
