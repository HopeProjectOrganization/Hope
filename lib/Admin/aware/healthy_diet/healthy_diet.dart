import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/category_model.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';
import 'package:hope/ui/shared_widgets/utils/healthy_diet_category.dart';
import 'package:provider/provider.dart';

class AdminHealthyDiet extends StatelessWidget {
  static const routeName = '/adminHealthyDiet';

  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  AdminHealthyDiet({super.key});

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    final List<CategoryModel> categories = [
      CategoryModel(
          image: AppAssets.recommended,
          id: 'RECOMMENDED_FOODS',
          route: '/RECOMMENDED_FOODS'),
      CategoryModel(
          image: AppAssets.recommended, id: 'RECIPES', route: '/RECIPES'),
      CategoryModel(
          image: AppAssets.helpful,
          id: 'HELPFUL_FOODS',
          route: '/HELPFUL_FOODS'),
      CategoryModel(
          image: AppAssets.helpful, id: 'BAD_FOODS', route: '/BAD_FOODS'),
    ];

    return CustomScaffold(
      backgroundColor: AppColors.lavender,
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
                                    '/dietCategoryScreen',
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
