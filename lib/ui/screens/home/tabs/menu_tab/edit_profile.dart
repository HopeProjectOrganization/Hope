import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/profile/profile_service.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/avatar.dart';
import 'package:hope/model/get_profile.dart';
import 'package:hope/ui/screens/profileDetails/avatar_sheet.dart';
import 'package:hope/ui/screens/profileDetails/edit_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  static const String routeName = "editProfile";

  final String? token;
  final GetUserProfileData? user;

  const EditProfile({super.key, this.token, this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late AppLocalizations appLocalizations;

  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  late String? selectedAvatarAsset;
  String? selectedAvatarId;

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
      fetchUserProfile(storedToken);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> showAvatarSheet(
      BuildContext context, String? currentAvatarAsset) async {
    final result = await showModalBottomSheet<Map<String, String?>>(
      context: context,
      backgroundColor: AppColors.gray,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) =>
          AvatarSheet(selectedAvatarAsset: currentAvatarAsset),
    );

    if (result != null) {
      setState(() {
        selectedAvatarAsset = result['asset'];
        selectedAvatarId = result['id'];
      });
    }
  }

  Future<void> fetchUserProfile(String token) async {
    GetUserProfile fetchUserProfile = GetUserProfile();
    Data? profileData = await fetchUserProfile.fetchUserProfile(token);

    if (mounted) {
      setState(() {
        userProfile = profileData;
        selectedAvatarId = userProfile!.avatarId ?? "5";
        selectedAvatarAsset = Avatar.getAvatarById(selectedAvatarId!);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations =
        AppLocalizations.of(context) ?? AppLocalizations.of(context)!;
    if (isLoading || selectedAvatarAsset == null || selectedAvatarId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_outlined,
            color: AppColors.Teal,
          ),
            onPressed: () {
            Navigator.pop(context, true);
          },
          ),
          title: Text(appLocalizations.editProfile),
          centerTitle: true,
        ),
      body: EditProfileForm(
        userProfile: userProfile!,
        token: token ?? widget.token,
      ),
    ));
  }

}
