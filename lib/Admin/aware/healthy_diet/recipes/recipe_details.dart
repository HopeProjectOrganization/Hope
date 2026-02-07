import 'package:flutter/material.dart';
import 'package:hope/Api/healthy_diet/healthy_recipe_service.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/model/healthy_recipes.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String mealId;

  const RecipeDetailScreen({Key? key, required this.mealId}) : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  RecipeModel? recipe;
  bool isLoading = true;
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
  }

  Future<void> fetchMealDetails() async {
    try {
      final data = await RecipeService.getRecipeById(widget.mealId);
      setState(() {
        recipe = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget buildIngredientsList() {
    if (recipe?.ingredients == null || recipe!.ingredients.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("No ingredients available."),
      );
    }

    final ingredientList = recipe!.ingredients.entries.toList();

    return Column(
      children: List.generate(ingredientList.length, (index) {
        final entry = ingredientList[index];
        final ingredientName = entry.key;
        final measurement = entry.value;

        return Card(
          color: AppColors.cloudi,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.yellow,
                  radius: 18,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: AppColors.Teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    ingredientName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  measurement,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.Teal)),
      );
    }

    if (recipe == null) {
      return const Scaffold(
        body: Center(child: Text('No recipe found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.Teal),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          appLocalizations.recipeDetails,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    child: Image.network(
                      recipe!.imageUrl ?? '',
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      recipe!.name,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.Teal),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: buildIngredientsList(),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: CustomButton(
                      title: appLocalizations.startCooking,
                      onClick: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeStepsScreen(
                            instructions: recipe!.instructions,
                            youtubeUrl: recipe!.youtubeUrl,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeStepsScreen extends StatefulWidget {
  final String instructions;
  final String? youtubeUrl;

  const RecipeStepsScreen({
    super.key,
    required this.instructions,
    this.youtubeUrl,
  });

  @override
  State<RecipeStepsScreen> createState() => _RecipeStepsScreenState();
}

class _RecipeStepsScreenState extends State<RecipeStepsScreen> {
  late List<String> steps;
  int currentStep = 0;
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  @override
  void initState() {
    super.initState();
    steps = widget.instructions
        .split(RegExp(r'\.(\s+|\n)'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> _launchYoutube() async {
    if (widget.youtubeUrl == null) return;
    final url = Uri.parse(widget.youtubeUrl!);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch video")),
      );
    }
  }

  Widget buildCustomButton({
    required String text,
    required VoidCallback onPressed,
    Color? color,
    IconData? icon,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.Teal,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 4,
      ),
      icon: icon != null
          ? Icon(
              icon,
              size: 20,
              color: AppColors.white,
            )
          : const SizedBox.shrink(),
      label: Text(text,
          style: const TextStyle(fontSize: 18, color: AppColors.white)),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    final String? youtubeUrl = widget.youtubeUrl;
    final String? videoId =
        youtubeUrl != null ? Uri.parse(youtubeUrl).queryParameters['v'] : null;

    return CustomScaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            if (videoId != null)
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    'http://img.youtube.com/vi/$videoId/0.jpg',
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    iconSize: 80,
                    icon: const Icon(Icons.play_circle_fill,
                        color: AppColors.white),
                    onPressed: _launchYoutube,
                  ),
                ],
              ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "${appLocalizations.step} ${currentStep + 1}",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 24),
                    StepIndicators(
                        currentStep: currentStep, totalSteps: steps.length),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(steps[currentStep],
                            style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentStep > 0)
                          buildCustomButton(
                            text: appLocalizations.previous,
                            icon: Icons.arrow_back_ios,
                            color: Colors.grey[100],
                            onPressed: () => setState(() => currentStep--),
                          )
                        else
                          const SizedBox(width: 140),
                        buildCustomButton(
                          text: currentStep < steps.length - 1
                              ? appLocalizations.next
                              : appLocalizations.finish,
                          icon: currentStep < steps.length - 1
                              ? Icons.arrow_forward_ios
                              : Icons.check,
                          onPressed: () {
                            if (currentStep < steps.length - 1) {
                              setState(() => currentStep++);
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      title: '',
    );
  }
}

class StepIndicators extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicators({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 20 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: isActive ? AppColors.yellow : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}