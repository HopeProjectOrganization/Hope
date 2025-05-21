import 'package:flutter/material.dart';
import 'package:hope/Api/healthy_diet/vegan.dart';
import 'package:hope/model/vegan.dart';
import 'package:hope/ui/screens/aware/healthy_diet/vegan_details.dart';
import 'package:hope/ui/shared_widgets/vegan_card.dart';

class VeganScreen extends StatefulWidget {
  const VeganScreen({super.key});

  static const routeName = '/Vegan';

  @override
  State<VeganScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<VeganScreen> {
  late Future<List<VeganRecipe>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = VeganService.fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vegan Recipes'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<VeganRecipe>>(
        future: futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes found'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final recipe = snapshot.data![index];
                return VeganCard(
                  recipe: recipe,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipeDetailsScreen(recipeId: recipe.id),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
