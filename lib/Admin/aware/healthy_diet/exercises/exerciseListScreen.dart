import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Admin/aware/healthy_diet/exercises/add_exercies.dart';
import 'package:hope/Api/healthy_diet/exercises_service.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/exercises.dart';
import 'package:hope/Admin/aware/healthy_diet/exercises/exerciseDetailScreen.dart';
import 'package:provider/provider.dart';

class AdminExerciseListScreen extends StatefulWidget {
  final String bodyPart;

  const AdminExerciseListScreen({super.key, required this.bodyPart});

  @override
  State<AdminExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<AdminExerciseListScreen> {
  late Future<List<Exercise>> futureExercises;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  void loadExercises() {
    ExerciseApiService apiService = ExerciseApiService();
    futureExercises = apiService.fetchExercisesByBodyPart(widget.bodyPart);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
            "${widget.bodyPart.toUpperCase()} ${appLocalizations.exercises}"),
      ),
      body: FutureBuilder<List<Exercise>>(
        future: futureExercises,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final exercises = snapshot.data!;
          return ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ExerciseDetailScreen(exercise: exercise),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        child: Image.network(
                          exercise.gifUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ExerciseDetailScreen(exercise: exercise),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.teal),
                          onPressed: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AdminAddExerciseScreen(
                                  bodyPart: widget.bodyPart,
                                  exercise: exercise,
                                ),
                              ),
                            );
                            if (updated == true) {
                              setState(() {
                                loadExercises();
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Confirm Delete"),
                                content: const Text(
                                    "Are you sure you want to delete this exercise?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(true),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              try {
                                await ExerciseApiService()
                                    .deleteExercise(exercise.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Exercise deleted successfully")),
                                );
                                setState(() {
                                  loadExercises();
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error deleting: $e")),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdminAddExerciseScreen(bodyPart: widget.bodyPart),
            ),
          );
          if (result == true) {
            setState(() {
              loadExercises(); // إعادة تحميل التمارين بعد الإضافة
            });
          }
        },
        backgroundColor: AppColors.Teal,
        child: const Icon(Icons.add, color: AppColors.yellow),
      ),
    );
  }
}
