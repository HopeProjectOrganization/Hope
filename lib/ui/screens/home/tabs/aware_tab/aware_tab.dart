import 'package:flutter/material.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/model/category_model.dart';
import 'package:hope/ui/shared_widgets/category_item_widget.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';

class AwareTab extends StatelessWidget {
  static const String routeName = '/aware_tab';

  AwareTab({super.key});

  final List<CategoryModel> categories = [
    CategoryModel(image: AppAssets.places, id: "Places", route: '/hereditary'),
    CategoryModel(
        image: AppAssets.awareness, id: "Awareness", route: '/hereditary'),
    CategoryModel(
        image: AppAssets.hereditary, id: "Hereditary", route: '/hereditary'),
    CategoryModel(
        image: AppAssets.alternative, id: "Alternative", route: '/hereditary'),
    CategoryModel(
        image: AppAssets.highRiskPeople,
        id: "High risk people",
        route: '/hereditary'),
    CategoryModel(
        image: AppAssets.healthyDiet, id: "Healthy diet", route: '/hereditary'),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'News',
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryItemWidget(
                        title: category.id,
                        onTap: () {
                          Navigator.pushNamed(context, category.route);
                        },
                        index: index,
                        image: category.image);
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
