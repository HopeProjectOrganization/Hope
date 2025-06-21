import 'package:flutter/material.dart';
import 'package:hope/Api/saved/favorite_service.dart';
import 'package:hope/core/theme/app_colors.dart';

class SavedListScreen extends StatefulWidget {
  static const String routeName = "savedlist";

  @override
  State<SavedListScreen> createState() => _SavedListScreenState();
}

class _SavedListScreenState extends State<SavedListScreen> {
  List<dynamic> favorites = [];
  String? selectedCategory;
  bool isLoading = false;

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
    loadAllCategoriesFavorites();
  }

  Future<void> loadAllCategoriesFavorites() async {
    setState(() => isLoading = true);
    try {
      List<dynamic> allFavorites = [];
      for (String category in allCategories) {
        final response = await FavoriteApiService.getByCategory(category);
        allFavorites.addAll(response);
      }
      setState(() => favorites = allFavorites);
    } catch (e) {
      print("Error loading favorites: $e");
      _showError("Failed to load favorites");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> loadFavoritesByCategory(String category) async {
    setState(() => isLoading = true);
    try {
      final response = await FavoriteApiService.getByCategory(category);
      setState(() => favorites = response);
    } catch (e) {
      print("Error loading favorites: $e");
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
                loadAllCategoriesFavorites();
              } else {
                selectedCategory = value;
                loadFavoritesByCategory(value);
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
              : _buildGroupedFavorites(),
    );
  }

  Widget _buildGroupedFavorites() {
    Map<String, List<dynamic>> grouped = {};
    for (var fav in favorites) {
      String type = fav['type'];
      if (!grouped.containsKey(type)) {
        grouped[type] = [];
      }
      grouped[type]!.add(fav);
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: grouped.entries.map((entry) {
        final type = entry.key;
        final items = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$type (${items.length})",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...items.map((item) => _buildFavoriteItem(item)).toList(),
            const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildFavoriteItem(dynamic item) {
    String type = item['type'];
    String category = item['category'];
    String mealId = item['mealId'];

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
        try {
          await FavoriteApiService.deleteById(mealId);
          if (selectedCategory == null) {
            loadAllCategoriesFavorites();
          } else {
            loadFavoritesByCategory(selectedCategory!);
          }
        } catch (e) {
          print("Error deleting: $e");
          _showError("Failed to delete item");
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              color: AppColors.lavender,
              margin: const EdgeInsets.only(right: 16),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Type: $type",
                      style: const TextStyle(color: Colors.grey)),
                  Text("Category: $category",
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(mealId,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
