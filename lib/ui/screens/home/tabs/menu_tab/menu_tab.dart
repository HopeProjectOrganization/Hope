import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/profile/profile_service.dart';
import 'package:hope/core/providers/locale_provider.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/get_profile.dart';
import 'package:hope/ui/screens/profileDetails/profile_body.dart';
import 'package:hope/ui/shared_widgets/custom_scaffold.dart';
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

  String? selectedAvatarId;
  String? selectedAvatarAsset;

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
        if (profileData != null) {
          userProfile = profileData;
          isLoading = false;
        } else {
          userProfile = null;
          isLoading = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    localeProvider = Provider.of<LocaleProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    // ✅ تحديث البيانات بعد أول رسم للشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (token != null && !isLoading) {
        fetchUserProfile(token!);
      }
    });

    return CustomScaffold(
      title: "Profile",
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.Teal),
            )
          : userProfile == null
              ? const Center(
                  child: Text("Failed to load profile"),
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
