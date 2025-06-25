import 'package:flutter/material.dart';
import 'package:hope/Api/saved/favorite_service.dart';
import 'package:hope/core/theme/app_colors.dart';

class FavoriteButton extends StatefulWidget {
  final String id;
  final String category;
  final String type;

  const FavoriteButton({
    Key? key,
    required this.id,
    required this.category,
    required this.type,
  }) : super(key: key);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  Future<void> checkFavoriteStatus() async {
    try {
      final result = await FavoriteApiService.isFavorite(widget.id);
      setState(() {
        isFavorite = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Error checking favorite: $e");
    }
  }

  Future<void> toggleFavorite() async {
    try {
      if (isFavorite) {
        await FavoriteApiService.deleteById(widget.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Removed from favorites")),
        );
      } else {
        await FavoriteApiService.saveFavorite(
          widget.id,
          widget.category,
          widget.type,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Saved to favorites")),
        );
      }

      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      print("Error toggling favorite: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update favorite")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return IconButton(
      onPressed: toggleFavorite,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? AppColors.red : AppColors.dark,
      ),
    );
  }
}
