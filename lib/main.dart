import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hope/Admin/add/add_high_ingredient.dart';
import 'package:hope/Admin/add/admin_product_screen.dart';
import 'package:hope/Admin/add/admin_products_screen.dart';
import 'package:hope/Admin/aware/alternative/alternative_screen.dart';
import 'package:hope/Admin/aware/awareness/addNewsScreen.dart';
import 'package:hope/Admin/aware/awareness/news_screen.dart';
import 'package:hope/Admin/aware/healthy_diet/exercises/exercises_screen.dart';
import 'package:hope/Admin/aware/healthy_diet/healthy_diet.dart';
import 'package:hope/Admin/aware/healthy_diet/recipes/healthy_recipes.dart';
import 'package:hope/Admin/aware/healthy_diet/vegan/add_vegan.dart';
import 'package:hope/Admin/aware/healthy_diet/vegan/edit_vegan.dart';
import 'package:hope/Admin/aware/healthy_diet/vegan/vegan_screen.dart';
import 'package:hope/Admin/aware/hereditary/addHereditaryScreen.dart';
import 'package:hope/Admin/aware/hereditary/hereditary.dart';
import 'package:hope/Admin/aware/high_risk/AdminAddArticleScreen.dart';
import 'package:hope/Admin/aware/high_risk/high_risk_people.dart';
import 'package:hope/Admin/aware/mealsense/add_meal.dart';
import 'package:hope/Admin/aware/mealsense/admin_meal_details.dart';
import 'package:hope/Admin/aware/mealsense/admin_meals.dart';
import 'package:hope/Admin/aware/places/admin_places_edit.dart';
import 'package:hope/Admin/aware/places/places_screen.dart';
import 'package:hope/Admin/aware/shared_widgets/article/article_screen.dart';
import 'package:hope/Admin/home/home.dart';
import 'package:hope/Admin/home/tabs/aware_tab/aware_tab.dart';
import 'package:hope/Api/notification/check_meals.dart';
import 'package:hope/core/providers/locale_provider.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_theme.dart';
import 'package:hope/fruit.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:hope/model/vegan_details.dart';
import 'package:hope/ui/screens/auth/forgetpassword/forgetpassword.dart';
import 'package:hope/ui/screens/auth/forgetpassword/resetpassword.dart';
import 'package:hope/ui/screens/auth/forgetpassword/verify/verification.dart';
import 'package:hope/ui/screens/auth/login/login.dart';
import 'package:hope/ui/screens/auth/register/register.dart';
import 'package:hope/ui/screens/aware/alternative/alternative_screen.dart';
import 'package:hope/ui/screens/aware/awareness/newsScreen.dart';
import 'package:hope/ui/screens/aware/healthy_diet/exercises/exercises_screen.dart';
import 'package:hope/ui/screens/aware/healthy_diet/healthy_diet.dart';
import 'package:hope/ui/screens/aware/healthy_diet/recipes/healthy_recipes.dart';
import 'package:hope/ui/screens/aware/healthy_diet/vegan/vegan_screen.dart';
import 'package:hope/ui/screens/aware/meal_sence/meal_sence_screen.dart';
import 'package:hope/ui/screens/aware/meal_sence/my_meals.dart';
import 'package:hope/ui/screens/aware/meal_sence/recipe_details.dart';
import 'package:hope/ui/screens/aware/places/places_screen.dart';
import 'package:hope/ui/screens/aware/shared_widgets/article/article_screen.dart';
import 'package:hope/ui/screens/home/home.dart';
import 'package:hope/ui/screens/home/tabs/add_tab/add_tab.dart';
import 'package:hope/ui/screens/home/tabs/aware_tab/aware_tab.dart';
import 'package:hope/ui/screens/home/tabs/menu_tab/edit_profile.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/result.dart';
import 'package:hope/ui/screens/home/tabs/scan_tab/scan_tab.dart';
import 'package:hope/ui/screens/onBoarding_screens/on_boarding/onboarding_screen.dart';
import 'package:hope/ui/screens/onBoarding_screens/set_up/setup_screen.dart';
import 'package:hope/ui/screens/onBoarding_screens/splash/splash_screen.dart';
import 'package:hope/ui/screens/profileDetails/change_password.dart';
import 'package:hope/ui/screens/profileDetails/saved/saved_list.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'ui/screens/aware/meal_sence/meals.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _showNotification(message);
}

Future<void> _showNotification(RemoteMessage message) async {
  final notification = message.notification;
  final android = message.notification?.android;

  if (notification != null) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      platformChannelSpecifics,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    _showNotification(message); // إشعار في foreground
  });

  FirebaseMessaging.instance.subscribeToTopic("users");

  // 🛠 تفعيل Workmanager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // ✅ مهمة لمرة واحدة بعد 10 ثواني فقط (للاختبار)
  Workmanager().registerOneOffTask(
    "testTask", // unique name
    "mealReminderTask", // نفس اسم المهمة
    initialDelay: const Duration(seconds: 10),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: MyApp(),
    ),
  );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  static String IP = "graduation-project-production-4619.up.railway.app";
  MyApp({super.key});

  late ThemeProvider themeProvider;

  late LocaleProvider localeProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(localeProvider.locale),
      debugShowCheckedModeBanner: false,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        OnBoardingScreen.routeName: (_) => const OnBoardingScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        SetupScreen.routeName: (_) => SetupScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        ForgetpasswordScreen.routeName: (_) => const ForgetpasswordScreen(),
        VerficationScreen.routeName: (_) => const VerficationScreen(),
        ResetpasswordScreen.routeName: (_) => const ResetpasswordScreen(),
        AwareTab.routeName: (_) => AwareTab(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        ScanTab.routeName: (_) => const ScanTab(),
        SuggestedReplacementsScreen.routeName: (_) =>
            const SuggestedReplacementsScreen(),
        AddTab.routeName: (_) => const AddTab(),
        ResultScreen.routeName: (_) => const ResultScreen(),
        NewsScreen.routeName: (_) => NewsScreen(),
        PlacesScreen.routeName: (_) => PlacesScreen(),
        NewsArticleScreen.routeName: (_) => const NewsArticleScreen(),
        HealthyDiet.routeName: (_) => HealthyDiet(),
        EditProfile.routeName: (_) => const EditProfile(),
        ChangePasswordScreen.routeName: (_) => const ChangePasswordScreen(),
        SavedListScreen.routeName: (_) => const SavedListScreen(),
        AdminHomeScreen.routeName: (_) => const AdminHomeScreen(),
        AdminAwareTab.routeName: (_) => AdminAwareTab(),
        AdminNewsScreen.routeName: (_) => AdminNewsScreen(),
        AdminNewsEditor.routeName: (_) => AdminNewsEditor(),
        AdminHereditary.routeName: (_) => const AdminHereditary(),
        AdminHereditaryEditorScreen.routeName: (_) =>
            const AdminHereditaryEditorScreen(),
        AdminNewsArticleScreen.routeName: (_) => const AdminNewsArticleScreen(),
        AdminAddArticleScreen.routeName: (context) => AdminAddArticleScreen(),
        AdminBodyPartScreen.routeName: (_) => AdminBodyPartScreen(),
        AdminRecipes.routeName: (_) => AdminRecipes(),
        AdminHighRiskPeople.routeName: (_) => AdminHighRiskPeople(),
        AdminHealthyDiet.routeName: (_) => AdminHealthyDiet(),
        AdminVeganScreen.routeName: (_) => const AdminVeganScreen(),
        AdminProductManagementScreen.routeName: (_) =>
            const AdminProductManagementScreen(),
        AddVeganRecipeScreen.routeName: (_) => const AddVeganRecipeScreen(),
        AdminMeals.routeName: (_) => const AdminMeals(),
        AdminMealDetails.routeName: (context) {
          final meal = ModalRoute.of(context)!.settings.arguments as Meal;
          return AdminMealDetails(meal: meal);
        },
        AddMeal.routeName: (_) => const AddMeal(),
        AdminSuggestedReplacementsScreen.routeName: (_) =>
            AdminSuggestedReplacementsScreen(),
        AdminHighRiskScreen.routeName: (_) => const AdminHighRiskScreen(),
        AdminProductsScreen.routeName: (_) => const AdminProductsScreen(),
        Recipes.routeName: (_) => Recipes(),
        BodyPartScreen.routeName: (_) => BodyPartScreen(),
        VeganScreen.routeName: (_) => const VeganScreen(),
        RecipeDetails.routeName: (context) {
          final id = ModalRoute.of(context)!.settings.arguments as String;
          return RecipeDetails(id: id);
        },
        EditVeganRecipeScreen.routeName: (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as VeganRecipeModel;
          return EditVeganRecipeScreen(recipe: args);
        },
        MyMealsScreen.routeName: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          final List<Meal> selectedMeals =
              args?['selectedMeals'] as List<Meal>? ?? <Meal>[];
          final String title = args?['title'] as String? ?? '';
          final DateTime selectedDate = args?['selectedDate'] as DateTime? ??
              DateTime.now(); // ✅ حل المشكلة هنا

          return MyMealsScreen(
            selectedMeals: selectedMeals,
            title: title,
            selectedDate: selectedDate, // ✅ استخدمه هنا
          );
        },

        MealSenceScreen.routeName: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          final List<Meal> selectedMeals =
              args?['selectedMeals'] as List<Meal>? ?? <Meal>[];
          final String title = args?['title'] as String? ?? '';
          final DateTime Date = args?['selectedDate'] as DateTime? ??
              DateTime.now(); // ✅ حل المشكلة هنا

          return MealSenceScreen(
            selectedMeals: selectedMeals,
            title: title,
            Date: Date, // ✅ استخدمه هنا
          );
        },
        Meals.routeName: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final String title = args?['title'] as String? ?? '';
          final DateTime selectedDate = args?['selectedDate'] as DateTime? ??
              DateTime.now(); // ✅ حل المشكلة هنا

          return Meals(
            title: title,
            selectedDate: selectedDate, // ✅ استخدمه هنا
          );
        },
        // ProgressScreen.routeName: (context) {
        //   final args = ModalRoute.of(context)?.settings.arguments
        //       as Map<String, dynamic>?;
        //   final Meal selectedMeal = args?['meal'] as Meal;
        //   return ProgressScreen(meal: selectedMeal);
        // },
        //  FilterScreen.routeName: (_) => const FilterScreen(),
        PlacesAdminScreen.routeName: (_) => PlacesAdminScreen(),
        AdminAddHospitalScreen.routeName: (_) => const AdminAddHospitalScreen(),
        ExploreScreen.routeName: (_) => const ExploreScreen()
      },
      initialRoute: RegisterScreen.routeName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
    );
  }
}