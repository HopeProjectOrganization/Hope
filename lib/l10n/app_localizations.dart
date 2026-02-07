import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Personalize Your Experience'**
  String get setupTitle;

  /// No description provided for @setupDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred theme and language to get started with a comfortable, tailored experience that suits your style.'**
  String get setupDescription;

  /// No description provided for @letsStart.
  ///
  /// In en, this message translates to:
  /// **'Let’s Start'**
  String get letsStart;

  /// No description provided for @onBoardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Scan Product '**
  String get onBoardingTitle1;

  /// No description provided for @onBoardingDescription1.
  ///
  /// In en, this message translates to:
  /// **'Dive into a world of events crafted to fit your unique interests. Whether you\'re into live music, art workshops, professional networking, or simply discovering new experiences, we have something for everyone. Our curated recommendations will help you explore, connect, and make the most of every opportunity around you.'**
  String get onBoardingDescription1;

  /// No description provided for @onBoardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Add Product '**
  String get onBoardingTitle2;

  /// No description provided for @onBoardingDescription2.
  ///
  /// In en, this message translates to:
  /// **'Take the hassle out of organizing events with our all-in-one planning tools. From setting up invites and managing RSVPs to scheduling reminders and coordinating details, we’ve got you covered. Plan with ease and focus on what matters – creating an unforgettable experience for you and your guests.'**
  String get onBoardingDescription2;

  /// No description provided for @onBoardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Awareness'**
  String get onBoardingTitle3;

  /// No description provided for @onBoardingDescription3.
  ///
  /// In en, this message translates to:
  /// **'Make every event memorable by sharing the experience with others. Our platform lets you invite friends, keep everyone in the loop, and celebrate moments together. Capture and share the excitement with your network, so you can relive the highlights and cherish the memories.'**
  String get onBoardingDescription3;

  /// No description provided for @onBoardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Chat bot'**
  String get onBoardingTitle4;

  /// No description provided for @onBoardingDescription4.
  ///
  /// In en, this message translates to:
  /// **'Make every event memorable by sharing the experience with others. Our platform lets you invite friends, keep everyone in the loop, and celebrate moments together. Capture and share the excitement with your network, so you can relive the highlights and cherish the memories.'**
  String get onBoardingDescription4;

  /// No description provided for @onBoardingDescription5.
  ///
  /// In en, this message translates to:
  /// **'Small habits, big impact. \n Discover healthy meals, daily exercises, and lifestyle tips that support cancer prevention and overall wellness. \n Make every day a healthier step forward.'**
  String get onBoardingDescription5;

  /// No description provided for @onBoardingDescription6.
  ///
  /// In en, this message translates to:
  /// **'Stay on track with your daily nutrition.\n Meal Sense helps you log your meals and keeps you within your recommended calories, fats, proteins, and carbs. \n Get insights tailored to your health goals'**
  String get onBoardingDescription6;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forgetPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @googleLogin.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get googleLogin;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @smoking.
  ///
  /// In en, this message translates to:
  /// **'Are you smoking ?'**
  String get smoking;

  /// No description provided for @hadCancer.
  ///
  /// In en, this message translates to:
  /// **'Have you had cancer?'**
  String get hadCancer;

  /// No description provided for @familyCancer.
  ///
  /// In en, this message translates to:
  /// **'Has anyone in your family had cancer ? '**
  String get familyCancer;

  /// No description provided for @typeOfCancer.
  ///
  /// In en, this message translates to:
  /// **'What type of cancer ?'**
  String get typeOfCancer;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @loginNow.
  ///
  /// In en, this message translates to:
  /// **'Login Now'**
  String get loginNow;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @enterEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or mobile phone'**
  String get enterEmailOrPhone;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the verification code'**
  String get enterVerificationCode;

  /// No description provided for @receiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code?'**
  String get receiveCode;

  /// No description provided for @sendAgain.
  ///
  /// In en, this message translates to:
  /// **'Send Again'**
  String get sendAgain;

  /// No description provided for @enterNewPass.
  ///
  /// In en, this message translates to:
  /// **'Please enter the new password'**
  String get enterNewPass;

  /// No description provided for @newPass.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPass;

  /// No description provided for @confirmNewPass.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPass;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @pleaseFillOutBothFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill out both fields'**
  String get pleaseFillOutBothFields;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @yourPasswordHasBeenReset.
  ///
  /// In en, this message translates to:
  /// **'Your password has been reset'**
  String get yourPasswordHasBeenReset;

  /// No description provided for @enterYourEmailOrMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or mobile phone'**
  String get enterYourEmailOrMobile;

  /// No description provided for @invalidEmailOrPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or phone number'**
  String get invalidEmailOrPhoneNumber;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @aware.
  ///
  /// In en, this message translates to:
  /// **'Aware'**
  String get aware;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @notScannedYet.
  ///
  /// In en, this message translates to:
  /// **'Not scanned yet'**
  String get notScannedYet;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'back'**
  String get back;

  /// No description provided for @textScanner.
  ///
  /// In en, this message translates to:
  /// **'Text scanner'**
  String get textScanner;

  /// No description provided for @scanCanceled.
  ///
  /// In en, this message translates to:
  /// **'Scan canceled'**
  String get scanCanceled;

  /// No description provided for @errorDuringScanning.
  ///
  /// In en, this message translates to:
  /// **'Error occurred during scanning!'**
  String get errorDuringScanning;

  /// No description provided for @barcodeScanner.
  ///
  /// In en, this message translates to:
  /// **'Barcode Scanner'**
  String get barcodeScanner;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @startScanning.
  ///
  /// In en, this message translates to:
  /// **'Start Scanning'**
  String get startScanning;

  /// No description provided for @scannedBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scanned Barcode Result'**
  String get scannedBarcode;

  /// No description provided for @noTextRecognized.
  ///
  /// In en, this message translates to:
  /// **'No text recognized!'**
  String get noTextRecognized;

  /// No description provided for @errorRecognizingText.
  ///
  /// In en, this message translates to:
  /// **'Error recognizing text: '**
  String get errorRecognizingText;

  /// No description provided for @pickFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Pick from Gallery'**
  String get pickFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takePhoto;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @breast.
  ///
  /// In en, this message translates to:
  /// **'Breast'**
  String get breast;

  /// No description provided for @prostate.
  ///
  /// In en, this message translates to:
  /// **'Prostate'**
  String get prostate;

  /// No description provided for @ovarian.
  ///
  /// In en, this message translates to:
  /// **'Ovarian'**
  String get ovarian;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @places.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get places;

  /// No description provided for @awareness.
  ///
  /// In en, this message translates to:
  /// **'Awareness'**
  String get awareness;

  /// No description provided for @hereditary.
  ///
  /// In en, this message translates to:
  /// **'Hereditary'**
  String get hereditary;

  /// No description provided for @alternative.
  ///
  /// In en, this message translates to:
  /// **'Alternative'**
  String get alternative;

  /// No description provided for @highRiskPeople.
  ///
  /// In en, this message translates to:
  /// **'High risk people'**
  String get highRiskPeople;

  /// No description provided for @healthyDiet.
  ///
  /// In en, this message translates to:
  /// **'Healthy diet'**
  String get healthyDiet;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @elderly.
  ///
  /// In en, this message translates to:
  /// **'Elderly'**
  String get elderly;

  /// No description provided for @pregnant.
  ///
  /// In en, this message translates to:
  /// **'Pregnant'**
  String get pregnant;

  /// No description provided for @weakImmunesystem.
  ///
  /// In en, this message translates to:
  /// **'Weak immune system'**
  String get weakImmunesystem;

  /// No description provided for @smokers.
  ///
  /// In en, this message translates to:
  /// **'Smokers'**
  String get smokers;

  /// No description provided for @obese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get obese;

  /// No description provided for @geneticMutation.
  ///
  /// In en, this message translates to:
  /// **'Genetic mutation'**
  String get geneticMutation;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @chemicalexposure.
  ///
  /// In en, this message translates to:
  /// **'Chemical exposure'**
  String get chemicalexposure;

  /// No description provided for @pollutedareas.
  ///
  /// In en, this message translates to:
  /// **'Polluted areas'**
  String get pollutedareas;

  /// No description provided for @chooseTheProductType.
  ///
  /// In en, this message translates to:
  /// **'Choose the product type :'**
  String get chooseTheProductType;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @cancerTreatmentPlaces.
  ///
  /// In en, this message translates to:
  /// **'Cancer treatment'**
  String get cancerTreatmentPlaces;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @updateAccount.
  ///
  /// In en, this message translates to:
  /// **'Update Account'**
  String get updateAccount;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @ar.
  ///
  /// In en, this message translates to:
  /// **'AR'**
  String get ar;

  /// No description provided for @en.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get en;

  /// No description provided for @noMealsYet.
  ///
  /// In en, this message translates to:
  /// **'No meals yet.'**
  String get noMealsYet;

  /// No description provided for @mealSense.
  ///
  /// In en, this message translates to:
  /// **'Meal Sense'**
  String get mealSense;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get meals;

  /// No description provided for @noMealsFound.
  ///
  /// In en, this message translates to:
  /// **'No meals found.'**
  String get noMealsFound;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @myMealsFor.
  ///
  /// In en, this message translates to:
  /// **'My Meals for'**
  String get myMealsFor;

  /// No description provided for @totalCalories.
  ///
  /// In en, this message translates to:
  /// **'Total Calories :'**
  String get totalCalories;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @addTo.
  ///
  /// In en, this message translates to:
  /// **'Add to'**
  String get addTo;

  /// No description provided for @todayProgress.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Progress'**
  String get todayProgress;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @serving.
  ///
  /// In en, this message translates to:
  /// **'Serving'**
  String get serving;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By Category'**
  String get byCategory;

  /// No description provided for @muscles.
  ///
  /// In en, this message translates to:
  /// **'Muscles : '**
  String get muscles;

  /// No description provided for @howToDoIt.
  ///
  /// In en, this message translates to:
  /// **'How To Do It'**
  String get howToDoIt;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @exercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercises;

  /// No description provided for @chooseYourTrain.
  ///
  /// In en, this message translates to:
  /// **'Choose your train'**
  String get chooseYourTrain;

  /// No description provided for @recipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get recipes;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category: '**
  String get category;

  /// No description provided for @recipeDetails.
  ///
  /// In en, this message translates to:
  /// **'Recipe Details'**
  String get recipeDetails;

  /// No description provided for @startCooking.
  ///
  /// In en, this message translates to:
  /// **'Start Cooking'**
  String get startCooking;

  /// No description provided for @couldNotLaunchVideo.
  ///
  /// In en, this message translates to:
  /// **'Could not launch video'**
  String get couldNotLaunchVideo;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @noDetailsFound.
  ///
  /// In en, this message translates to:
  /// **'No details found.'**
  String get noDetailsFound;

  /// No description provided for @preparationSteps.
  ///
  /// In en, this message translates to:
  /// **'Preparation Steps'**
  String get preparationSteps;

  /// No description provided for @veganRecipes.
  ///
  /// In en, this message translates to:
  /// **'Vegan Recipes'**
  String get veganRecipes;

  /// No description provided for @noRecipesFound.
  ///
  /// In en, this message translates to:
  /// **'No recipes found'**
  String get noRecipesFound;

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'View more'**
  String get viewMore;

  /// No description provided for @beauty.
  ///
  /// In en, this message translates to:
  /// **'Beauty'**
  String get beauty;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @typeOfProduct.
  ///
  /// In en, this message translates to:
  /// **'Type of product :'**
  String get typeOfProduct;

  /// No description provided for @addHospital.
  ///
  /// In en, this message translates to:
  /// **'Add Hospital'**
  String get addHospital;

  /// No description provided for @editHospital.
  ///
  /// In en, this message translates to:
  /// **'Edit Hospital'**
  String get editHospital;

  /// No description provided for @hospitalAdded.
  ///
  /// In en, this message translates to:
  /// **'Hospital added successfully'**
  String get hospitalAdded;

  /// No description provided for @hospitalUpdated.
  ///
  /// In en, this message translates to:
  /// **'Hospital updated successfully'**
  String get hospitalUpdated;

  /// No description provided for @hospitalSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save hospital'**
  String get hospitalSaveFailed;

  /// No description provided for @pleasePickImage.
  ///
  /// In en, this message translates to:
  /// **'Please pick an image'**
  String get pleasePickImage;

  /// No description provided for @imageUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image'**
  String get imageUploadFailed;

  /// No description provided for @noImageSelected.
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get noImageSelected;

  /// No description provided for @hospitalName.
  ///
  /// In en, this message translates to:
  /// **'Hospital Name'**
  String get hospitalName;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @googleMapsLink.
  ///
  /// In en, this message translates to:
  /// **'Google Maps Link'**
  String get googleMapsLink;

  /// No description provided for @pickImageFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Pick Image from Gallery'**
  String get pickImageFromGallery;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @editeMeal.
  ///
  /// In en, this message translates to:
  /// **'Edit Meal'**
  String get editeMeal;

  /// No description provided for @mealName.
  ///
  /// In en, this message translates to:
  /// **'Meal Name'**
  String get mealName;

  /// No description provided for @prepareTime.
  ///
  /// In en, this message translates to:
  /// **'Prepare Time (min)'**
  String get prepareTime;

  /// No description provided for @cookTime.
  ///
  /// In en, this message translates to:
  /// **'Cook Time (min)'**
  String get cookTime;

  /// No description provided for @servings.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get servings;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @ingredientsComma.
  ///
  /// In en, this message translates to:
  /// **'Ingredients (comma separated)'**
  String get ingredientsComma;

  /// No description provided for @mealSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps (use | between steps)'**
  String get mealSteps;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags (comma separated)'**
  String get tags;

  /// No description provided for @updateMeal.
  ///
  /// In en, this message translates to:
  /// **'Update Meal'**
  String get updateMeal;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @addMeal.
  ///
  /// In en, this message translates to:
  /// **'Add Meal'**
  String get addMeal;

  /// No description provided for @tapToSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to select image'**
  String get tapToSelectImage;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @mondayShort.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mondayShort;

  /// No description provided for @tuesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesdayShort;

  /// No description provided for @wednesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesdayShort;

  /// No description provided for @thursdayShort.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursdayShort;

  /// No description provided for @fridayShort.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fridayShort;

  /// No description provided for @saturdayShort.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturdayShort;

  /// No description provided for @sundayShort.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sundayShort;

  /// No description provided for @savedList.
  ///
  /// In en, this message translates to:
  /// **'Saved List'**
  String get savedList;

  /// No description provided for @exercise.
  ///
  /// In en, this message translates to:
  /// **'exercise'**
  String get exercise;

  /// No description provided for @noExerciseYet.
  ///
  /// In en, this message translates to:
  /// **'No favorite exercise yet.'**
  String get noExerciseYet;

  /// No description provided for @bodyPart.
  ///
  /// In en, this message translates to:
  /// **'Body Part'**
  String get bodyPart;

  /// No description provided for @noFavoriteMealsYet.
  ///
  /// In en, this message translates to:
  /// **'No favorite meals yet.'**
  String get noFavoriteMealsYet;

  /// No description provided for @noFavoritePostsYet.
  ///
  /// In en, this message translates to:
  /// **'No favorite posts yet.'**
  String get noFavoritePostsYet;

  /// No description provided for @articleName.
  ///
  /// In en, this message translates to:
  /// **'Artical Name'**
  String get articleName;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @deletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get deletedSuccessfully;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get errorPrefix;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this article?'**
  String get confirmDeleteMessage;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @productType.
  ///
  /// In en, this message translates to:
  /// **'Product Type'**
  String get productType;

  /// No description provided for @ingredientName.
  ///
  /// In en, this message translates to:
  /// **'Ingredient Name'**
  String get ingredientName;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// No description provided for @addIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add Ingredient'**
  String get addIngredient;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @errorFailedToUpdate.
  ///
  /// In en, this message translates to:
  /// **'❌ Error: Failed to update'**
  String get errorFailedToUpdate;

  /// No description provided for @addHighIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add Ingredient'**
  String get addHighIngredient;

  /// No description provided for @editHighIngredient.
  ///
  /// In en, this message translates to:
  /// **'Edit Ingredient'**
  String get editHighIngredient;

  /// No description provided for @riskLevel.
  ///
  /// In en, this message translates to:
  /// **'Risk Level'**
  String get riskLevel;

  /// No description provided for @safeLimit.
  ///
  /// In en, this message translates to:
  /// **'Safe Limit'**
  String get safeLimit;

  /// No description provided for @englishDescription.
  ///
  /// In en, this message translates to:
  /// **'English Description'**
  String get englishDescription;

  /// No description provided for @arabicDescription.
  ///
  /// In en, this message translates to:
  /// **'Arabic Description'**
  String get arabicDescription;

  /// No description provided for @errorSaving.
  ///
  /// In en, this message translates to:
  /// **'❌ Error occurred while saving'**
  String get errorSaving;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @addProducts.
  ///
  /// In en, this message translates to:
  /// **'Add Products'**
  String get addProducts;

  /// No description provided for @addHighRiskIngredients.
  ///
  /// In en, this message translates to:
  /// **'Add High Risk Ingredients'**
  String get addHighRiskIngredients;

  /// No description provided for @editIngredient.
  ///
  /// In en, this message translates to:
  /// **'Edit Ingredients'**
  String get editIngredient;

  /// No description provided for @highRiskIngredients.
  ///
  /// In en, this message translates to:
  /// **'High Risk Ingredients'**
  String get highRiskIngredients;

  /// No description provided for @errorUpdate.
  ///
  /// In en, this message translates to:
  /// **'Failed to update'**
  String get errorUpdate;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @deleteThisProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete this product?'**
  String get deleteThisProduct;

  /// No description provided for @codeExpired.
  ///
  /// In en, this message translates to:
  /// **'The code has expired. Please request a new one.'**
  String get codeExpired;

  /// No description provided for @codeResentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent successfully.'**
  String get codeResentSuccess;

  /// No description provided for @codeResentFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to resend the code.'**
  String get codeResentFail;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Invalid code. Please check again.'**
  String get verificationFailed;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 4-digit code.'**
  String get invalidCode;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'A network error occurred. Please try again later.'**
  String get networkError;

  /// No description provided for @timeLeft.
  ///
  /// In en, this message translates to:
  /// **'Time left: {seconds} seconds'**
  String timeLeft(Object seconds);

  /// No description provided for @codeExpiredShort.
  ///
  /// In en, this message translates to:
  /// **'Code expired! Please resend.'**
  String get codeExpiredShort;

  /// No description provided for @failedToLoadFavorites.
  ///
  /// In en, this message translates to:
  /// **'Failed to load favorites'**
  String get failedToLoadFavorites;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get oldPassword;

  /// No description provided for @pleaseFillOutAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill out all fields'**
  String get pleaseFillOutAllFields;

  /// No description provided for @errorResettingPassword.
  ///
  /// In en, this message translates to:
  /// **'Error resetting password'**
  String get errorResettingPassword;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @noName.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get noName;

  /// No description provided for @noPhone.
  ///
  /// In en, this message translates to:
  /// **'No phone'**
  String get noPhone;

  /// No description provided for @accountUpdated.
  ///
  /// In en, this message translates to:
  /// **'Account updated successfully'**
  String get accountUpdated;

  /// No description provided for @updateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile. Please try again later.'**
  String get updateError;

  /// No description provided for @deleteError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again later.'**
  String get deleteError;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedToLoadProfile;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to logout'**
  String get logoutFailed;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @scanFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to scan the barcode. Please try again.'**
  String get scanFailed;

  /// No description provided for @riskRate.
  ///
  /// In en, this message translates to:
  /// **'Risk Rate'**
  String get riskRate;

  /// No description provided for @noHighRiskIngredientsFound.
  ///
  /// In en, this message translates to:
  /// **'No high-risk ingredients found.'**
  String get noHighRiskIngredientsFound;

  /// No description provided for @noScanYet.
  ///
  /// In en, this message translates to:
  /// **'No barcode scanned yet.'**
  String get noScanYet;

  /// No description provided for @scanResult.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get scanResult;

  /// No description provided for @noScanResult.
  ///
  /// In en, this message translates to:
  /// **'No result from scan.'**
  String get noScanResult;

  /// No description provided for @noMessage.
  ///
  /// In en, this message translates to:
  /// **'No message'**
  String get noMessage;

  /// No description provided for @productAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product successfully added!'**
  String get productAddedSuccessfully;

  /// No description provided for @scanCancelledOrFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan was cancelled or failed'**
  String get scanCancelledOrFailed;

  /// No description provided for @unknownProduct.
  ///
  /// In en, this message translates to:
  /// **'Unknown Product'**
  String get unknownProduct;

  /// No description provided for @unknownBarcode.
  ///
  /// In en, this message translates to:
  /// **'Unknown Barcode'**
  String get unknownBarcode;

  /// No description provided for @failedToFetchProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch user profile.'**
  String get failedToFetchProfile;

  /// No description provided for @tokenNotFound.
  ///
  /// In en, this message translates to:
  /// **'Authentication token not found.'**
  String get tokenNotFound;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get errorOccurred;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @recentlyScanned.
  ///
  /// In en, this message translates to:
  /// **'Recently Scanned'**
  String get recentlyScanned;

  /// No description provided for @failedToLoadRecentScan.
  ///
  /// In en, this message translates to:
  /// **'Failed to load recently scanned products.'**
  String get failedToLoadRecentScan;

  /// No description provided for @recentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently Added'**
  String get recentlyAdded;

  /// No description provided for @failedToLoadRecentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Failed to load recently added products.'**
  String get failedToLoadRecentlyAdded;

  /// No description provided for @noTextDetected.
  ///
  /// In en, this message translates to:
  /// **'No text detected'**
  String get noTextDetected;

  /// No description provided for @scanCancelled.
  ///
  /// In en, this message translates to:
  /// **'Scan cancelled'**
  String get scanCancelled;

  /// No description provided for @scanningError.
  ///
  /// In en, this message translates to:
  /// **'Error occurred during scanning'**
  String get scanningError;

  /// No description provided for @noNutrientFound.
  ///
  /// In en, this message translates to:
  /// **'No nutrient values found.'**
  String get noNutrientFound;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields.'**
  String get pleaseFillAllFields;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatTitle;

  /// No description provided for @askYourQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask your question...'**
  String get askYourQuestion;

  /// No description provided for @errorSendingMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while sending your message. Please try again.'**
  String get errorSendingMessage;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password may be incorrect.'**
  String get invalidCredentials;

  /// No description provided for @fetchProfileFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch user profile.'**
  String get fetchProfileFailed;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @unknownRole.
  ///
  /// In en, this message translates to:
  /// **'Unknown role: {role}'**
  String unknownRole(Object role);

  /// No description provided for @failedToLoadUserData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load user data.'**
  String get failedToLoadUserData;

  /// No description provided for @invalidEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get invalidEmailOrPassword;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get loginFailed;

  /// No description provided for @loginErrorTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again later.'**
  String get loginErrorTryAgain;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'The email address is badly formatted'**
  String get invalidEmail;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @typeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select the type'**
  String get typeRequired;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Please select the type'**
  String get selectType;

  /// No description provided for @resetPasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Reset password failed. Please try again.'**
  String get resetPasswordFailed;

  /// No description provided for @resetPasswordError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while resetting your password.'**
  String get resetPasswordError;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @searchForAlternative.
  ///
  /// In en, this message translates to:
  /// **'Search for Alternative'**
  String get searchForAlternative;

  /// No description provided for @topAlternativesTo.
  ///
  /// In en, this message translates to:
  /// **'Top alternatives to {productName}'**
  String topAlternativesTo(Object productName);

  /// No description provided for @whyBetter.
  ///
  /// In en, this message translates to:
  /// **'Why it’s better:'**
  String get whyBetter;

  /// No description provided for @nutritionInfo.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Info:'**
  String get nutritionInfo;

  /// No description provided for @noScannedProducts.
  ///
  /// In en, this message translates to:
  /// **'No scanned products yet!'**
  String get noScannedProducts;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @failedToFetchAlternatives.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch alternatives. Please try again.'**
  String get failedToFetchAlternatives;

  /// No description provided for @failedToLoadHistory.
  ///
  /// In en, this message translates to:
  /// **'Failed to load history.'**
  String get failedToLoadHistory;

  /// No description provided for @suggestAlternativesFor.
  ///
  /// In en, this message translates to:
  /// **'Suggest healthy alternatives for'**
  String get suggestAlternativesFor;

  /// No description provided for @seeResult.
  ///
  /// In en, this message translates to:
  /// **'See result'**
  String get seeResult;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
