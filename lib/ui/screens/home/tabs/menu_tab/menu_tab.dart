import 'package:flutter/material.dart';
import 'package:hope/Api/profile/profile_service.dart';
import 'package:hope/core/providers/locale_provider.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/model/get_profile.dart';
import 'package:hope/ui/screens/profileDetails/profile_body.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';
import 'package:hope/ui/shared_widgets/utils/dialog_utils.dart';
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
      await fetchUserProfile(storedToken);
    } else {
      setState(() {
        isLoading = false;
      });
      showMessage(context, appLocalizations.tokenNotFound);
    }
  }

  Future<void> fetchUserProfile(String token) async {
    try {
      final GetUserProfile getUserProfile = GetUserProfile();
      final Data? profileData = await getUserProfile.fetchUserProfile(token);

      if (mounted) {
        if (profileData != null) {
          setState(() {
            userProfile = profileData;
            isLoading = false;
          });
        } else {
          showMessage(
            context,
            appLocalizations.failedToLoadProfile,
          );
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      showMessage(
        context,
        appLocalizations.errorOccurred,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    localeProvider = Provider.of<LocaleProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    // ✅ تأكيد تحديث البيانات بعد أول رسم للشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (token != null && !isLoading) {
        fetchUserProfile(token!);
      }
    });

    return CustomScaffold(
      title: appLocalizations.profile,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.Teal),
            )
          : userProfile == null
              ? Center(
                  child: Text(
                    appLocalizations.failedToLoadProfile,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : ProfileBody(
                  localeProvider: localeProvider,
                  themeProvider: themeProvider,
                  appLocalizations: appLocalizations,
                  token: token,
                  userProfile: userProfile,
                ),
    );
  }
}
