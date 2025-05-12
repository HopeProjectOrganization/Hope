import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/profile/profile_service.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/avatar.dart';
import 'package:hope/model/get_profile.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:hope/ui/shared_widgets/custom_text_field.dart';
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

  //late String selectedAvatarAsset;
  // late int selectedAvatarId;
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  late String selectedAvatarAsset;
  late String selectedAvatarId;

  Data? userProfile;
  bool isLoading = true;
  String? token;

  // @override
  // void initState() {
  //   super.initState();
  //   // selectedAvatarAsset =
  //   //     Avatar.getAvatarById(widget.user!.data!.avaterId ?? 0);
  //   // selectedAvatarId = widget.user!.data!.avaterId ?? 0;
  // }
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
        selectedAvatarId = userProfile!.avatarId ?? "5";
        selectedAvatarAsset = Avatar.getAvatarById(selectedAvatarId);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations =
        AppLocalizations.of(context) ?? AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: AppColors.purple,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(appLocalizations.editProfile),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  showAvatarBottomSheet(context);
                },
                child: Container(
                  margin: EdgeInsets.all(35),
                  child: Center(
                    child: Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage(selectedAvatarAsset),
                          ),
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.purple,
                            child: Icon(Icons.edit,
                                size: 16, color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              CustomTextField(
                hint: userProfile?.username ?? "No Name",
                controller: userNameController,
                prefixIcon: ImageIcon(AssetImage(AppIcons.userIcon)),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: userProfile?.email ?? "No email",
                prefixIcon: ImageIcon(AssetImage(AppIcons.emailIcon)),
                controller: emailController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: userProfile?.phone ?? "No email",
                prefixIcon: ImageIcon(AssetImage(AppIcons.phoneIcon)),
                controller: phoneController,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional.centerStart,
              ),
              const SizedBox(
                height: 40,
              ),
              Spacer(),
              CustomButton(
                title: appLocalizations.updateAccount,
                onClick: () async {
                  //final avatarService = AvatarService(token: widget.token!);

                  // await avatarService.updateAvatar(
                  //   email: emailController.text.trim().isEmpty
                  //       ? widget.user!.data!.email ?? ""
                  //       : emailController.text.trim(),
                  //   avatarId: selectedAvatarId.toString(),
                  //   phone: phoneController.text.trim().isEmpty
                  //       ? widget.user!.data!.phone ?? ""
                  //       : phoneController.text.trim(),
                  //   context: context,
                  // );
                  // setState(() {});
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                color: AppColors.red,
                title: appLocalizations.deleteAccount,
                onClick: () async {
                  //    await DeleteService().deleteProfile(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void showAvatarBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.gray,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return Container(
              height: 400,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: Avatar.avatars.length,
                      itemBuilder: (context, index) {
                        final avatar = Avatar.avatars[index];
                        bool isSelected =
                            avatar['asset'] == selectedAvatarAsset;

                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              setStateBottomSheet(() {
                                selectedAvatarAsset = avatar['asset'];
                                selectedAvatarId = avatar['id'];
                              });
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.purple.withOpacity(0.6)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.purple,
                                width: 3,
                              ),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                avatar['asset'],
                                fit: BoxFit.cover,
                                width: 70,
                                height: 70,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
