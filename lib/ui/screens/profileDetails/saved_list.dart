import 'package:flutter/material.dart';
import 'package:hope/Api/saved/favorite_service.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/favorite.dart';

class SavedListScreen extends StatefulWidget {
  static const String routeName = "savedlist";

  @override
  State<SavedListScreen> createState() => _SavedListScreenState();
}

class _SavedListScreenState extends State<SavedListScreen> {
  List<FavoriteMeal> favorites = [];
  bool isLoading = false;
  String? selectedCategory;

  final List<String> allCategories = [
    'NEWS',
    'HEREDITARY',
    'AWARENESS',
    'HEALTHY_DIET',
    'HIGH_RISK_PEOPLE',
  ];

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  Future<void> loadAll() async {
    setState(() => isLoading = true);
    try {
      favorites = await FavoriteApiService.getAllFavorites();
    } catch (e) {
      _showError("Failed to load favorites");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> loadByCategory(String category) async {
    setState(() => isLoading = true);
    try {
      favorites = await FavoriteApiService.getByCategory(category);
    } catch (e) {
      _showError("Failed to load favorites");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.Teal,
        title:
            const Text("Saved List", style: TextStyle(color: AppColors.white)),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'All') {
                selectedCategory = null;
                loadAll();
              } else {
                selectedCategory = value;
                loadByCategory(value);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'All', child: Text('All')),
              ...allCategories
                  .map((cat) => PopupMenuItem(value: cat, child: Text(cat))),
            ],
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? const Center(child: Text('No favorites found.'))
              : _buildFavoritesList(),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final fav = favorites[index];
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          background: Container(
            color: AppColors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) async {
            await FavoriteApiService.deleteById(fav.mealId);
            if (selectedCategory == null) {
              await loadAll();
            } else {
              await loadByCategory(selectedCategory!);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Meal ID: ${fav.mealId}",
                    style: const TextStyle(fontSize: 16)),
                Text("Category: ${fav.category}",
                    style: const TextStyle(color: Colors.grey)),
                Text("Type: ${fav.type}",
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        );
      },
    );
  }
}
