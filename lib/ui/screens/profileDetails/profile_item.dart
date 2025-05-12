import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/shared_widgets/utils/language_button.dart';

class ProfileItem extends StatelessWidget {
  final IconData? icon;
  final bool language;
  final String title;
  final VoidCallback? onTap;
  final BuildContext context;

  const ProfileItem({
    Key? key,
    this.icon,
    this.language = false,
    required this.title,
    this.onTap,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(width: 16),
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
}
