import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/healthy_diet/healthy_recipe.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
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
  Map<String, dynamic>? mealDetails;
  bool isLoading = true;
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
  }

  Future<void> fetchMealDetails() async {
    try {
      final data = await MealService.getMealDetailsById(widget.mealId);
      setState(() {
        mealDetails = data;
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
    List<Widget> ingredientWidgets = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = mealDetails?['strIngredient$i'];
      final measure = mealDetails?['strMeasure$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredientWidgets.add(
          Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.purple.withOpacity(0.2),
                child: Text('$i',
                    style: TextStyle(
                        color: AppColors.purple, fontWeight: FontWeight.bold)),
              ),
              title: Text(ingredient, style: const TextStyle(fontSize: 18)),
              trailing: Text(measure ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            ),
          ),
        );
      }
    }
    return Column(children: ingredientWidgets);
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.purple),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(appLocalizations.recipeDetails,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(children: [
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
                          mealDetails?['strMealThumb'] ?? '',
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          mealDetails?['strMeal'] ?? '',
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
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
                                instructions:
                                    mealDetails?['strInstructions'] ?? '',
                                youtubeUrl: mealDetails?['strYoutube'],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
    );
  }
}

class RecipeStepsScreen extends StatefulWidget {
  final String instructions;
  final String? youtubeUrl;

  const RecipeStepsScreen(
      {super.key, required this.instructions, this.youtubeUrl});

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
        backgroundColor: color ?? AppColors.purple,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 4,
      ),
      icon: icon != null ? Icon(icon, size: 20) : const SizedBox.shrink(),
      label: Text(text, style: const TextStyle(fontSize: 18)),
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
                    'https://img.youtube.com/vi/$videoId/0.jpg',
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    iconSize: 80,
                    icon:
                        const Icon(Icons.play_circle_fill, color: Colors.white),
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

  const StepIndicators(
      {Key? key, required this.currentStep, required this.totalSteps})
      : super(key: key);

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
            color: isActive ? AppColors.purple : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}
