import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/screens/aware/healthy_diet/exercises/exerciseListScreen.dart';
import 'package:provider/provider.dart';

class BodyPartScreen extends StatelessWidget {
  static const routeName = '/Exercises';

  BodyPartScreen({super.key});

  final Map<String, String> bodyPartImages = {
    "back": AppAssets.ex1,
    "cardio": AppAssets.ex2,
    "chest": AppAssets.ex3,
    "lower arms": AppAssets.ex4,
    "lower legs": AppAssets.ex1,
    "neck": AppAssets.ex1,
    "shoulders": AppAssets.ex1,
    "upper arms": AppAssets.ex1,
    "upper legs": AppAssets.ex1,
    "waist": AppAssets.ex1,
  };

  final List<String> bodyParts = [
    "back",
    "cardio",
    "chest",
    "lower arms",
    "lower legs",
    "neck",
    "shoulders",
    "upper arms",
    "upper legs",
    "waist",
  ];

  @override
  Widget build(BuildContext context) {
    late ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    late AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: Text(appLocalizations.chooseYourTrain)),
      body: ListView.builder(
        itemCount: bodyParts.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xffe7e1f6),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bodyParts[index].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ExerciseListScreen(
                                  bodyPart: bodyParts[index]),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                appLocalizations.viewMore,
                                style: TextStyle(
                                  color: AppColors.Teal,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward_ios_rounded,
                                  size: 14, color: AppColors.Teal),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    bodyPartImages[bodyParts[index]] ?? "",
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child:
                          const Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
