import 'package:flutter/material.dart';
import 'package:hope/Admin/aware/healthy_diet/vegan/add_vegan.dart';
import 'package:hope/Admin/aware/healthy_diet/vegan/admin_vegan_card.dart';
import 'package:hope/Admin/aware/healthy_diet/vegan/edit_vegan.dart';
import 'package:hope/Admin/aware/healthy_diet/vegan/vegan_details.dart';
import 'package:hope/Api/healthy_diet/vegan_service.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/vegan_details.dart';

class AdminVeganScreen extends StatefulWidget {
  const AdminVeganScreen({super.key});

  static const routeName = '/AdminVegan';

  @override
  State<AdminVeganScreen> createState() => _AdminVeganScreenState();
}

class _AdminVeganScreenState extends State<AdminVeganScreen> {
  late Future<List<VeganRecipeModel>> futureRecipes;

  @override
  void initState() {
    super.initState();
    _refreshRecipes();
  }

  void _refreshRecipes() {
    setState(() {
      futureRecipes = VeganRecipeService.getAllRecipes();
    });
  }

  void _deleteRecipe(String veganId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: const Text("Are you sure you want to delete this recipe?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete")),
        ],
      ),
    );

    if (confirm == true) {
      await VeganRecipeService.deleteByVeganId(veganId);
      _refreshRecipes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vegan Recipes"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.Teal,
        onPressed: () async {
          await Navigator.pushNamed(context, AddVeganRecipeScreen.routeName);
          _refreshRecipes();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<List<VeganRecipeModel>>(
        future: futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes found.'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final recipe = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AdminVeganCard(
                        recipe: recipe,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AdminRecipeDetailsScreen(id: recipe.id!),
                            ),
                          );
                        },
                        onEdit: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditVeganRecipeScreen(recipe: recipe),
                            ),
                          );
                          _refreshRecipes();
                        },
                        onDelete: () => _deleteRecipe(recipe.veganId),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
