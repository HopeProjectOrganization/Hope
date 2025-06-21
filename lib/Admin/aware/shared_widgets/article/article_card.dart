import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

class ArticleCard extends StatelessWidget {
  final String title, imageUrl, author, date;

  const ArticleCard({
    required this.title,
    required this.imageUrl,
    required this.author,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.lavender,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              // Ensures image covers the area properly
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(Icons.image_not_supported,
                      size: 100, color: AppColors.gray),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.Teal,
                      child:
                          Icon(Icons.person, size: 14, color: AppColors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      author,
                      style: const TextStyle(color: AppColors.gray),
                    ),
                    const Spacer(),
                    Text(
                      date,
                      style: const TextStyle(color: AppColors.gray),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
