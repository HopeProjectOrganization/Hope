import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Admin/aware/awareness/addNewsScreen.dart';
import 'package:hope/Admin/aware/awareness/news_screen.dart';
import 'package:hope/Admin/aware/healthy_diet/addHealthyScreen.dart';
import 'package:hope/Admin/aware/healthy_diet/diet_category_screen.dart';
import 'package:hope/Admin/aware/healthy_diet/healthy_diet.dart';
import 'package:hope/Admin/aware/hereditary/addHereditaryScreen.dart';
import 'package:hope/Admin/aware/hereditary/hereditary.dart';
import 'package:hope/Admin/aware/high_risk/addHighRiskScreen.dart';
import 'package:hope/Admin/aware/high_risk/high_risk_people.dart';
import 'package:hope/Admin/home/home.dart';
import 'package:hope/Admin/home/tabs/aware_tab/aware_tab.dart';
import 'package:hope/core/providers/locale_provider.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_theme.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:hope/test.dart';
import 'package:hope/ui/screens/auth/forgetpassword/forgetpassword.dart';
import 'package:hope/ui/screens/auth/forgetpassword/resetpassword.dart';
import 'package:hope/ui/screens/auth/forgetpassword/verify/verification.dart';
import 'package:hope/ui/screens/auth/login/login.dart';
import 'package:hope/ui/screens/auth/register/register.dart';
import 'package:hope/ui/screens/aware/alternative/alternative_screen.dart';
import 'package:hope/ui/screens/aware/awareness/newsScreen.dart';
import 'package:hope/ui/screens/aware/healthy_diet/healthy_diet.dart';
import 'package:hope/ui/screens/aware/hereditary/hereditary.dart';
import 'package:hope/ui/screens/aware/high_risk/high_risk_people.dart';
import 'package:hope/ui/screens/aware/meal_sence/filter_screen.dart';
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
import 'package:hope/ui/screens/profileDetails/saved_list.dart';
import 'package:provider/provider.dart';

import 'ui/screens/aware/meal_sence/meals.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
      ),
      //   ChangeNotifierProvider(create: (_) => RecentScannedProductsProvider())
    ], child: MyApp()),
  );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  static String IP = "192.168.1.57:8081";
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
        Hereditary.routeName: (_) => const Hereditary(),
        AwareTab.routeName: (_) => AwareTab(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        ScanTab.routeName: (_) => const ScanTab(),
        SuggestedReplacementsScreen.routeName: (_) =>
            SuggestedReplacementsScreen(),
        AddTab.routeName: (_) => const AddTab(),
        ResultScreen.routeName: (_) => const ResultScreen(),
        NewsScreen.routeName: (_) => NewsScreen(),
        PlacesScreen.routeName: (_) => PlacesScreen(),
        NewsArticleScreen.routeName: (_) => const NewsArticleScreen(),
        HighRiskPeople.routeName: (_) => HighRiskPeople(),
        HealthyDiet.routeName: (_) => HealthyDiet(),
        EditProfile.routeName: (_) => const EditProfile(),
        ChangePasswordScreen.routeName: (_) => const ChangePasswordScreen(),
        SavedListScreen.routeName: (_) => SavedListScreen(),
        AdminHomeScreen.routeName: (_) => const AdminHomeScreen(),
        AdminAwareTab.routeName: (_) => AdminAwareTab(),
        AdminNewsScreen.routeName: (_) => AdminNewsScreen(),
        AdminNewsEditorScreen.routeName: (_) => AdminNewsEditorScreen(),
        AdminHereditary.routeName: (_) => const AdminHereditary(),
        AdminHereditaryEditorScreen.routeName: (_) =>
            AdminHereditaryEditorScreen(),
        AdminHighEditorScreen.routeName: (_) => AdminHighEditorScreen(),
        AdminHighRiskPeople.routeName: (_) => AdminHighRiskPeople(),
        AdminHealthyDiet.routeName: (_) => AdminHealthyDiet(),
        DietCategoryScreen.routeName: (_) => const DietCategoryScreen(),
        AdminHealthyEditorScreen.routeName: (_) =>
            const AdminHealthyEditorScreen(),
        RecipeDetails.routeName: (context) {
          final id = ModalRoute.of(context)!.settings.arguments as int;
          return RecipeDetails(id: id);
        },
        MyMealsScreen.routeName: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          final List<Meal> selectedMeals =
              args?['selectedMeals'] as List<Meal>? ?? <Meal>[];
          final String title = args?['title'] as String? ?? '';

          return MyMealsScreen(
            selectedMeals: selectedMeals,
            title: title,
          );
        },
        MealSenceScreen.routeName: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          final List<Meal> selectedMeals =
              args?['selectedMeals'] as List<Meal>? ?? <Meal>[];
          final String title = args?['title'] as String? ?? '';

          return MealSenceScreen(
            selectedMeals: selectedMeals,
            title: title,
          );
        },
        Meals.routeName: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final String title = args?['title'] as String? ?? '';

          return Meals(
            title: title,
          );
        },
        ProgressScreen.routeName: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final Meal selectedMeal = args?['meal'] as Meal;
          return ProgressScreen(meal: selectedMeal);
        },
        FilterScreen.routeName: (_) => FilterScreen(),
      },
      initialRoute: HomeScreen.routeName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
    );
  }
}
