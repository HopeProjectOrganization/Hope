import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/recipes/fetch_recipe.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:hope/test.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:hope/ui/shared_widgets/custom_gradient.dart';
import 'package:provider/provider.dart';

class RecipeDetails extends StatefulWidget {
  static const routeName = '/recipe';
  final int id;

  const RecipeDetails({super.key, required this.id});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails>
    with TickerProviderStateMixin {
  late Future<Meal> mealFuture;
  late TabController _tabController;
  bool isDescriptionExpanded = false;
  bool isPressed = false;

  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  @override
  void initState() {
    super.initState();
    mealFuture = fetchMealById(widget.id);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _nutrientCard(String title, String value, String icon, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: ImageIcon(
            AssetImage(icon),
            color: color,
          ),
        ),
        SizedBox(height: 6),
        Text(title, style: TextStyle(color: Colors.grey)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Meal>(
          future: mealFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              final meal = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: double.infinity,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                meal.imageUrl,
                                fit: BoxFit.cover,
                              ),
                              CustomGradient(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _circleIconButton(
                                  Icons.close, () => Navigator.pop(context)),
                              _circleIconButton(
                                  isPressed
                                      ? Icons.favorite
                                      : Icons.favorite_border, () {
                                setState(() {
                                  isPressed = !isPressed;
                                });
                              },
                                  iconColor: isPressed
                                      ? AppColors.red
                                      : AppColors.dark),
                            ],
                          ),
                        ),
                        Positioned(
                            top: MediaQuery.of(context).size.height * 0.36,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(40)),
                              ),
                              child: Container(),
                            ))
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(40)),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  meal.name,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Icon(Icons.access_time, color: Colors.grey),
                              SizedBox(width: 4),
                              Text(
                                  "${meal.prepTimeInMinutes} ${appLocalizations.min}",
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text("${meal.difficulty} ",
                                      style: TextStyle(color: AppColors.gray))),
                              Icon(Icons.room_service, color: Colors.grey),
                              SizedBox(width: 4),
                              Text(
                                  "${meal.serving} ${appLocalizations.serving} ",
                                  style: TextStyle(color: Colors.grey))
                            ],
                          ),
                          SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _nutrientCard(
                                  appLocalizations.carbs,
                                  "${meal.carbs}g",
                                  AppIcons.carbs, Colors.blue),
                              _nutrientCard(
                                  appLocalizations.protein,
                                  "${meal.protein}g",
                                  AppIcons.proteins, Colors.green),
                              _nutrientCard(
                                  appLocalizations.calories,
                                  "${meal.calories} Kcal",
                                  AppIcons.calories, Colors.red),
                              _nutrientCard(appLocalizations.fat,
                                  "${meal.fat}g", AppIcons.fats, Colors.orange),
                            ],
                          ),
                          SizedBox(height: 20),
                          DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppColors.purple),
                                  ),
                                  child: TabBar(
                                    controller: _tabController,
                                    indicatorPadding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                    // يزيد مساحة المؤشر أفقياً
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColors.purple,
                                    ),
                                    labelColor: AppColors.white,
                                    unselectedLabelColor: AppColors.purple,
                                    tabs: [
                                      Tab(text: appLocalizations.ingredients),
                                      Tab(text: appLocalizations.instructions),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 1.3,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      buildIngredients(meal),
                                      buildInstructions(meal),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomButton(
                            title: appLocalizations.add,
                            onClick: () {
                              Navigator.pushNamed(
                                context,
                                ProgressScreen.routeName,
                                arguments: {
                                  'meal': meal,
                                },
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildIngredients(Meal meal) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(), // يتحكم فيه السكول الرئيسي
      shrinkWrap: true,
      itemCount: meal.ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = meal.ingredients[index];
        final measurement =
            index < meal.measurements.length ? meal.measurements[index] : '';
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Row(
            children: [
              // صورة العنصر
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                        meal.categoryThumbnail), // يمكن تخصيصها لاحقًا
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  ingredient,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              // الكمية
              Text(
                "$measurement",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildInstructions(Meal meal) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: meal.directions.length,
      itemBuilder: (context, index) {
        final step = meal.directions[index];
        return Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // رقم الخطوة داخل دائرة
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.purple.withOpacity(0.1),
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: AppColors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // نص الخطوة
                    Expanded(
                      child: Text(
                        step,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Divider(
                  color: AppColors.purple,
                  height: 2,
                )
              ],
            ));
      },
    );
  }

  Widget _circleIconButton(IconData icon, VoidCallback onPressed,
      {Color? iconColor}) {
    return Material(
      color: Colors.white,
      shape: CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Icon(icon, color: iconColor ?? AppColors.dark),
        ),
      ),
    );
  }
}
