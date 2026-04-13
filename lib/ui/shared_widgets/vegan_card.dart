import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/vegan_details.dart';
import 'package:hope/ui/shared_widgets/halfCircleClipper.dart';

class VeganCard extends StatelessWidget {
  final VeganRecipeModel recipe;
  final VoidCallback onTap;

  const VeganCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
     String fixedImage = recipe.image.isNotEmpty
        ? 'https://images.weserv.nl/?url=${recipe.image.replaceFirst('https://', '')}'
        : '';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.lavender.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.dark,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.lavender.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        recipe.difficulty.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.Teal,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ClipPath(
              clipper: HalfCircleClipper(),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                  fixedImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
