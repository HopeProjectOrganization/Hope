// exercise_favorites.dart
import 'package:flutter/material.dart';
import 'package:hope/Api/healthy_diet/exercises_service.dart';
import 'package:hope/model/exercises.dart';
import 'package:hope/model/favorite.dart';
import 'package:hope/ui/screens/aware/healthy_diet/exercises/exerciseDetailScreen.dart';

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
    final exercises = favorites.where((fav) => fav.type == 'exercise').toList();

    if (exercises.isEmpty) {
      return const Center(child: Text('No Exercise yet.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final fav = exercises[index];
        final exerciseId = fav.mealId;
        print("sld,sld,s;,lds,lds ${exerciseId}");
        print("Exercise ID: $exerciseId (${exerciseId.runtimeType})");

        if (exerciseId == null) {
          return const Text('Invalid exercise ID');
        }

        return FutureBuilder<Exercise>(
          future: ExerciseApiService().getExerciseById(int.parse(exerciseId)),
          builder: (context, snapshot) {
            print("Exercise ID: $exerciseId (${exerciseId.runtimeType})");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Text('No exercise data');
            }

            final exercise = snapshot.data!;
            return GestureDetector(
              onTap: () async {
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
                  color: Colors.white,
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
                        errorBuilder: (context, error, stackTrace) => Container(
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
                          Text("Category: ${fav.category}",
                              style: const TextStyle(color: Colors.grey)),
                          Text("Type: ${fav.type}",
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
