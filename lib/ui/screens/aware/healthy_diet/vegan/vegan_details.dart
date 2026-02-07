// recipe_details_screen.dart
import 'package:flutter/material.dart';
import 'package:hope/Api/healthy_diet/vegan_service.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/model/vegan_details.dart';
import 'package:hope/ui/shared_widgets/favorite_button.dart';
import 'package:provider/provider.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final int id;

  const RecipeDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {}, // ممكن تسيبيه فاضي أو تشيليه لو مش محتاجاه
            child: FavoriteButton(
              id: id.toString(),
              category: 'VEGAN',
              type: 'meal',
            ),
          ),
        ],
        backgroundColor: AppColors.Teal,
        title: Text(appLocalizations.recipeDetails),
        centerTitle: true,
        elevation: 4,
        shadowColor: AppColors.lavender.withOpacity(0.5),
      ),
      body: FutureBuilder<VeganRecipeModel>(
        future: VeganRecipeService.getById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text(appLocalizations.noDetailsFound));
          }

          final recipe = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  child: Image.network(
                    recipe.image,
                    width: double.infinity,
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: AppColors.dark,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          Chip(
                            label: Text(recipe.difficulty),
                            backgroundColor:
                                AppColors.lavender.withOpacity(0.1),
                            avatar: const Icon(Icons.fitness_center,
                                size: 15, color: AppColors.Teal),
                          ),
                          Chip(
                            label: Text(recipe.portion),
                            backgroundColor:
                                AppColors.lavender.withOpacity(0.1),
                            avatar: const Icon(Icons.people,
                                size: 15, color: AppColors.Teal),
                          ),
                          Chip(
                            label: Text(recipe.time),
                            backgroundColor:
                                AppColors.lavender.withOpacity(0.1),
                            avatar: const Icon(Icons.timer,
                                size: 15, color: AppColors.Teal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        recipe.description,
                        style: const TextStyle(
                            fontSize: 17, height: 1.4, color: AppColors.dark),
                      ),
                      const SizedBox(height: 30),
                      _buildIngredients(recipe, appLocalizations),
                      const SizedBox(height: 30),
                      _buildSteps(recipe, appLocalizations),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIngredients(
      VeganRecipeModel recipe, AppLocalizations appLocalizations) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lavender.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant_menu, color: AppColors.Teal),
              const SizedBox(width: 8),
              Text(
                appLocalizations.ingredients,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: AppColors.Teal),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recipe.ingredients.map(
            (ingredient) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(Icons.circle,
                      size: 12, color: AppColors.Teal.withOpacity(0.7)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(ingredient)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSteps(
      VeganRecipeModel recipe, AppLocalizations appLocalizations) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lavender.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.format_list_numbered, color: AppColors.Teal),
              const SizedBox(width: 8),
              Text(
                appLocalizations.preparationSteps,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: AppColors.Teal),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recipe.steps.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColors.Teal,
                        child: Text('${entry.key + 1}',
                            style: const TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.value.stepTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(entry.value.stepDescription),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
