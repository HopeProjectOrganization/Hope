import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/auth/auth.dart';
import 'package:hope/Api/profile/profile_service.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/providers/locale_provider.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/avatar.dart';
import 'package:hope/model/get_profile.dart';
import 'package:hope/ui/screens/auth/forgetpassword/resetpassword.dart';
import 'package:hope/ui/screens/auth/login/login.dart';
import 'package:hope/ui/screens/home/tabs/menu_tab/edit_profile.dart';
import 'package:hope/ui/screens/profileDetails/custom_item.dart';
import 'package:hope/ui/screens/profileDetails/profile_item.dart';
import 'package:hope/ui/screens/profileDetails/saved/saved_list.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProfileBody extends StatefulWidget {
  static const routeName = '/ProfileBody';

  ProfileBody({
    super.key,
    required this.userProfile,
    required this.localeProvider,
    required this.themeProvider,
    required this.token,
    required this.appLocalizations,
  });

  Data? userProfile;
  late ThemeProvider themeProvider;
  late LocaleProvider localeProvider;
  late AppLocalizations appLocalizations;

  String? token;

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  Data? userProfile;

  bool isLoading = true;

  Future<void> fetchUserProfile(String token) async {
    setState(() => isLoading = true);
    GetUserProfile fetchUserProfile = GetUserProfile();
    Data? profileData = await fetchUserProfile.fetchUserProfile(token);

    if (mounted) {
      setState(() {
        widget.userProfile = profileData;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.token != null) {
      fetchUserProfile(widget.token!); // لازم يتم استدعاؤه عند تحميل الصفحة
    }
  }

  @override
  Widget build(BuildContext context) {
    late ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    if (widget.userProfile == null) {
      return const Center(
        child: Text("Failed to load profile"),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 30),
      child: Column(
        children: [
          Center(
              child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(60)),
                border: Border.all(color: AppColors.yellow, width: 2)),
            child: CircleAvatar(
              radius: 60,
              child: Image.asset(
                Avatar.getAvatarById(widget.userProfile?.avatarId ?? "5"),
                height: 118,
                width: 118,
                fit: BoxFit.contain,
              ),
            ),
          )),
          const SizedBox(height: 20),
          Center(
            child: Text(
              widget.userProfile?.name ?? "No Name",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          ProfileItem(
              icon: Icons.person,
              title: widget.appLocalizations.editProfile,
              context: context,
              onTap: () async {
                final result = await Navigator.pushNamed(
                  context,
                  EditProfile.routeName,
                  arguments: {'token': widget.token},
                );

                if (result == true) {
                  await fetchUserProfile(
                      widget.token!); // ✅ اعمل refresh للبيانات
                }
              }),
          ProfileItem(
              icon: Icons.notifications,
              title: widget.appLocalizations.notification,
              context: context,
              onTap: () {}),
          ProfileItem(
              icon: Icons.playlist_add_check,
              title: widget.appLocalizations.savedList,
              context: context,
              onTap: () {
                Navigator.pushNamed(context, SavedListScreen.routeName);
              }),
          ProfileItem(
            icon: Icons.lock,
            title: widget.appLocalizations.changePassword,
            context: context,
            onTap: () {
              Navigator.pushNamed(context, ResetpasswordScreen.routeName);
            },
          ),

          // ProfileItem(
          //     icon: Icons.location_on,
          //     title: widget.appLocalizations.address,
          //     context: context,
          //     onTap: () {}),
          CustomItem(
            localeProvider: widget.localeProvider,
            themeProvider: widget.themeProvider,
            customIcon: Icon(
              widget.themeProvider.isDark() ? EvaIcons.moon : EvaIcons.sun,
              color: AppColors.Teal,
            ),
            title: widget.appLocalizations.theme,
          ),
          CustomItem(
              localeProvider: widget.localeProvider,
              themeProvider: widget.themeProvider,
              iconData: Icons.language,
              title: widget.appLocalizations.language,
              language: true),
          const Spacer(),
          CustomButton(
            icon: const ImageIcon(AssetImage(AppIcons.exit)),
            title: widget.appLocalizations.exit,
            onClick: () async {
              await AuthApiService().logout();
              // بعد تسجيل الخروج انقله إلى شاشة تسجيل الدخول
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginScreen.routeName,
                (route) =>
                    false, // يمسح كل الـ stack ويبدأ من شاشة تسجيل الدخول
              );
            },
          )
        ],
      ),
    );
  }
}
