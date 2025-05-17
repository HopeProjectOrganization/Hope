import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/model/category_model.dart';
import 'package:hope/ui/shared_widgets/category_item_widget.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AwareTab extends StatelessWidget {
  static const String routeName = '/aware_tab';

  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  AwareTab({super.key});

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    final List<CategoryModel> categories = [
      CategoryModel(
          image: AppAssets.places,
          id: appLocalizations.places,
          route: '/places'),
      CategoryModel(
          image: AppAssets.awareness,
          id: appLocalizations.awareness,
          route: '/newsScreen'),
      CategoryModel(
          image: AppAssets.hereditary,
          id: appLocalizations.hereditary,
          route: '/hereditary'),
      CategoryModel(
          image: AppAssets.alternative,
          id: appLocalizations.alternative,
          route: '/alternative'),
      CategoryModel(
          image: AppAssets.highRiskPeople,
          id: appLocalizations.highRiskPeople,
          route: '/highRisk'),
      CategoryModel(
          image: AppAssets.healthyDiet,
          id: appLocalizations.healthyDiet,
          route: '/healthyDiet'),
      CategoryModel(
          image: AppAssets.mealSence, id: "Meal Sence", route: '/mealSence'),
    ];

    return CustomScaffold(
      title: appLocalizations.news,
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
                            child: CategoryItemWidget(
                                title: category.id,
                                onTap: () {
                          Navigator.pushNamed(context, category.route);
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
