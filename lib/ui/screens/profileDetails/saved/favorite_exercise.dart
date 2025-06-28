import 'package:flutter/material.dart';
import 'package:hope/Api/healthy_diet/exercises_service.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/exercises.dart';
import 'package:hope/model/favorite.dart';
import 'package:hope/ui/screens/aware/healthy_diet/exercises/exerciseDetailScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExerciseFavorites extends StatelessWidget {
  final List<FavoriteMeal> favorites;
  final VoidCallback onRefresh;

  const ExerciseFavorites({
    required this.favorites,
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final exerciseFavs =
        favorites.where((fav) => fav.type == 'exercise').toList();

    if (exerciseFavs.isEmpty) {
      return Center(child: Text(appLocalizations.noExerciseYet));
    }

    return FutureBuilder<List<Exercise>>(
      future: Future.wait(
        exerciseFavs.map((fav) =>
            ExerciseApiService().getExerciseById(int.parse(fav.mealId))),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(appLocalizations.noExerciseYet);
        }

        final exercises = snapshot.data!;
        final Map<String, List<Exercise>> categorizedExercises = {};

        for (var ex in exercises) {
          final category = (ex.bodyPart).trim();

          if (!categorizedExercises.containsKey(category)) {
            categorizedExercises[category] = [];
          }
          categorizedExercises[category]!.add(ex);
        }

        final sortedCategories = categorizedExercises.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

        return ListView(
          padding: const EdgeInsets.all(12),
          children: sortedCategories.expand<Widget>((entry) {
            final category = entry.key;
            final items = entry.value;

            return [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(category.toUpperCase(),
                    style: Theme.of(context).textTheme.labelLarge),
              ),
              ...items.map((exercise) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ExerciseDetailScreen(exercise: exercise),
                      ),
                    ).then((_) => onRefresh());
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cloudi,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            exercise.gifUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${appLocalizations.bodyPart} : ${exercise.bodyPart}",
                              ),
                              Text(
                                "${appLocalizations.muscles} : ${exercise.secondaryMuscles}",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
            ];
          }).toList(),
        );
      },
    );
  }
}
