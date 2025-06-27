import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

class ArticleCard extends StatelessWidget {
  final String title, date;
  final String? imageUrl, author;

  const ArticleCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.date,
    this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.lavender,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Article Image
// Article Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: (imageUrl != null && imageUrl!.trim().isNotEmpty)
                ? Image.network(
                    imageUrl!,
                    height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                            color: AppColors.Teal),
                      );
                    },
              errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholderImage();
                    },
                  )
                : _buildPlaceholderImage(),
          ),

          // Article Text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 12),

                // Author & Date
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.Teal,
                      child:
                          Icon(Icons.person, size: 14, color: AppColors.white),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        author ?? "Unknown",
                        style: const TextStyle(color: AppColors.gray),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.calendar_today,
                        size: 14, color: AppColors.gray),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style:
                          const TextStyle(color: AppColors.gray, fontSize: 12),
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

  Widget _buildPlaceholderImage() {
    return Container(
      height: 200,
      width: double.infinity,
      color: AppColors.gray.withOpacity(0.2),
      child: const Icon(
        Icons.image_not_supported,
        size: 60,
        color: AppColors.gray,
      ),
    );
  }
}
