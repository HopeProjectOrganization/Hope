import 'package:flutter/material.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/Api/saved/favorite_service.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/favorite.dart';
import 'package:hope/ui/screens/profileDetails/saved/favorite_article.dart';
import 'package:hope/ui/screens/profileDetails/saved/favorite_exercise.dart';
import 'package:hope/ui/screens/profileDetails/saved/favorite_meal.dart';
import 'package:hope/ui/shared_widgets/custome_tab.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
import 'package:provider/provider.dart';

class SavedListScreen extends StatefulWidget {
  static const String routeName = "savedlist";

  const SavedListScreen({super.key});

  @override
  State<SavedListScreen> createState() => _SavedListScreenState();
}

class _SavedListScreenState extends State<SavedListScreen>
    with TickerProviderStateMixin {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

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
      _showError(appLocalizations.failedToLoadFavorites);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    showMessage(context, message, posButtonTitle: appLocalizations.ok);
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
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.Teal,
        title: Text(
          appLocalizations.savedList,
          style: TextStyle(color: AppColors.white),
        ),
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
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 10),
                tabs: List.generate(3, (index) {
                  final titles = [
                    appLocalizations.posts,
                    appLocalizations.meals,
                    appLocalizations.exercises
                  ];
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
