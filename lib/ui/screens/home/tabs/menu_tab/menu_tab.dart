import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/auth/login/logout_service.dart';
import 'package:hope/Api/profile/profile_service.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/locale_provider.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/avatar.dart';
import 'package:hope/model/get_profile.dart';
import 'package:hope/ui/screens/home/tabs/menu_tab/edit_profile.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';
import 'package:hope/ui/shared_widgets/utils/language_button.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuTab extends StatefulWidget {
  const MenuTab({super.key});

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  late ThemeProvider themeProvider;
  late LocaleProvider localeProvider;
  late AppLocalizations appLocalizations;

  Data? userProfile;
  bool isLoading = true;
  String? token;
  int historyCount = 0;
  int wishListCount = 0;

  @override
  void initState() {
    super.initState();
    fetchToken();
  }

  Future<void> fetchToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('auth_token');

    if (storedToken != null) {
      setState(() {
        token = storedToken;
      });
      fetchUserProfile(storedToken);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserProfile(String token) async {
    GetUserProfile fetchUserProfile = GetUserProfile();
    Data? profileData = await fetchUserProfile.fetchUserProfile(token);

    if (mounted) {
      setState(() {
        userProfile = profileData;
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    localeProvider = Provider.of<LocaleProvider>(context);

    print('Building UserProfile'); // تأكد أن الـ build method يعمل
    print('Username: ${userProfile?.name ?? 'No Name'}');

    appLocalizations = AppLocalizations.of(context)!;

    return CustomScaffold(
      title: "Profile",
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.purple),
      )
          : userProfile == null
          ? const Center(
        child: Text("Failed to load profile"),
      )
          : _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    // التحقق أولاً من أن userProfile و data غير null
    if (userProfile == null) {
      return const Center(
        child: Text("Failed to load profile"),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 30),
      child: Column(
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              child: Image.asset(
                Avatar.getAvatarById(userProfile!.avatarId ?? "5"),
                height: 118,
                width: 118,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              "${userProfile?.name ?? "No Name"}",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          buildMenuItem(
              icon: Icons.person,
              title: appLocalizations.editProfile,
              context: context,
              onTap: () {
                Navigator.pushNamed(context, EditProfile.routeName);
              }),
          buildMenuItem(
              icon: Icons.notifications,
              title: appLocalizations.notification,
              context: context,
              onTap: () {}),
          buildMenuItem(
              icon: Icons.lock,
              title: appLocalizations.changePassword,
              context: context,
              onTap: () {}),
          buildMenuItem(
              icon: Icons.location_on,
              title: appLocalizations.address,
              context: context,
              onTap: () {}),
          buildCustomeItem(
            customIcon: Icon(
              themeProvider.isDark() ? EvaIcons.moon : EvaIcons.sun,
              color: AppColors.purple,
            ),
            title: appLocalizations.theme,
            context: context,
          ),
          buildCustomeItem(
              iconData: Icons.language,
              title: appLocalizations.language,
              context: context,
              language: true),
          Spacer(),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.07,
            child: CustomButton(
              icon: ImageIcon(AssetImage(AppIcons.exit)),
              title: appLocalizations.exit,
              onClick: () {
                LogoutService().logoutUser(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildMenuItem({
    IconData? icon,
    bool language = false,
    required String title,
    VoidCallback? onTap,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.lavender,
              radius: 20,
              child: FittedBox(
                child: Icon(icon, color: AppColors.purple),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            language
                ? LanguageButton()
                : const Icon(Icons.arrow_forward_ios,
                    size: 16, color: AppColors.gray)
          ],
        ),
      ),
    );
  }

  Widget buildCustomeItem({
    IconData? iconData,
    Widget? customIcon,
    bool language = false,
    required String title,
    required BuildContext context,
  }) {
    final iconWidget = customIcon ??
        (iconData != null
            ? Icon(iconData, color: AppColors.purple, size: 20)
            : null);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: InkWell(
        onTap: () {
          language
              ? localeProvider.locale =
                  localeProvider.locale == 'en' ? 'ar' : 'en'
              : themeProvider.themeMode =
                  themeProvider.isDark() ? ThemeMode.light : ThemeMode.dark;
        },
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.lavender,
              radius: 20,
              child: FittedBox(
                child: iconWidget,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Spacer(),
            language
                ? Text(
              localeProvider.locale == 'en'
                  ? AppLocalizations.of(context)!.en
                  : AppLocalizations.of(context)!.ar,
                    style: TextStyle(
                        color: AppColors.purple, fontWeight: FontWeight.bold),
                  )
                : Text(
              themeProvider.isDark()
                  ? appLocalizations.dark
                  : appLocalizations.light,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
          ],
        ),
      ),
    );
  }
}