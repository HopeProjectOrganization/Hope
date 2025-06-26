import 'package:flutter/material.dart';
import 'package:hope/Api/saved/favorite_service.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/favorite.dart';
import 'package:hope/ui/screens/profileDetails/saved/favorite_article.dart';
import 'package:hope/ui/screens/profileDetails/saved/favorite_exercise.dart';
import 'package:hope/ui/screens/profileDetails/saved/favorite_meal.dart';
import 'package:hope/ui/shared_widgets/custome_tab.dart';

class SavedListScreen extends StatefulWidget {
  static const String routeName = "savedlist";

  @override
  State<SavedListScreen> createState() => _SavedListScreenState();
}

class _SavedListScreenState extends State<SavedListScreen>
    with TickerProviderStateMixin {
  List<FavoriteMeal> favorites = [];
  bool isLoading = false;
  late TabController _tabController;
  final Map<String, String> articleCategories = {
    'NEWS': 'News',
    'HIGH_RISK': 'High risk people',
    'HEREDITARY_PEOPLE': 'Hereditary',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  List<FavoriteMeal> filterByType(String type) {
    if (type == 'exercise') {
      return favorites
          .where((fav) => fav.category.toUpperCase() == 'EXERCISE')
          .toList();
    }
    return favorites.where((fav) => fav.type == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.Teal,
        title:
            const Text("Saved List", style: TextStyle(color: AppColors.white)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AnimatedBuilder(
            animation: _tabController.animation!,
            builder: (context, _) {
              return TabBar(
                isScrollable: false,
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: const BoxDecoration(),
                labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(vertical: 10),
                tabs: List.generate(3, (index) {
                  final titles = ['Posts', 'Meals', 'Exercises'];
                  return CustomeTab(
                    text: titles[index],
                    isSelected:
                        _tabController.animation!.value.round() == index,
                  );
                }),
              );
            },
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                ArticleFavorites(
                  articleCategories: articleCategories,
                  onRefresh: loadAll,
                ),
                MealFavorites(
                  favorites: filterByType('meal'),
                  onRefresh: loadAll,
                ),
                ExerciseFavorites(
                  favorites: filterByType('exercise'),
                  onRefresh: loadAll,
                ),
              ],
            ),
    );
  }
}
