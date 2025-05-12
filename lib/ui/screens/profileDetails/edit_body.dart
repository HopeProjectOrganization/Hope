import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/profile/delete_service.dart';
import 'package:hope/Api/profile/update_profile_service.dart';
import 'package:hope/core/assets/app_icons.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/avatar.dart';
import 'package:hope/model/get_profile.dart';
import 'package:hope/ui/screens/profileDetails/avatar_sheet.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:hope/ui/shared_widgets/custom_text_field.dart';

class EditProfileForm extends StatefulWidget {
  final Data userProfile;
  final String? token;

  const EditProfileForm({
    super.key,
    required this.userProfile,
    required this.token,
  });

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late AppLocalizations appLocalizations;

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  late String? selectedAvatarAsset;
  String? selectedAvatarId;

  @override
  void initState() {
    super.initState();
    selectedAvatarId = widget.userProfile.avatarId ?? "5";
    selectedAvatarAsset = Avatar.getAvatarById(selectedAvatarId!);
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

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () async {
                await showAvatarSheet(context, selectedAvatarAsset);
              },
              child: Container(
                margin: const EdgeInsets.all(35),
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(selectedAvatarAsset!),
                      ),
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.purple,
                        child:
                            Icon(Icons.edit, size: 16, color: AppColors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomTextField(
              hint: widget.userProfile.name ?? "No Name",
              controller: userNameController,
              prefixIcon: const ImageIcon(AssetImage(AppIcons.userIcon)),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: widget.userProfile.email ?? "No email",
              prefixIcon: const ImageIcon(AssetImage(AppIcons.emailIcon)),
              controller: emailController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: widget.userProfile.phone ?? "No phone",
              prefixIcon: const ImageIcon(AssetImage(AppIcons.phoneIcon)),
              controller: phoneController,
            ),
            const SizedBox(height: 40),
            CustomButton(
              title: appLocalizations.updateAccount,
              onClick: () async {
                final avatarService = AvatarService(token: widget.token);

                await avatarService.updateAvatar(
                  name: userNameController.text.trim().isEmpty
                      ? widget.userProfile.name ?? ""
                      : userNameController.text.trim(),
                  email: emailController.text.trim().isEmpty
                      ? widget.userProfile.email ?? ""
                      : emailController.text.trim(),
                  avatarId:
                      selectedAvatarId ?? widget.userProfile.avatarId ?? "1",
                  phone: phoneController.text.trim().isEmpty
                      ? widget.userProfile.phone ?? ""
                      : phoneController.text.trim(),
                  context: context,
                );

                Navigator.pop(context, true);
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              color: AppColors.red,
              title: appLocalizations.deleteAccount,
              onClick: () async {
                await DeleteService().deleteProfile(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
