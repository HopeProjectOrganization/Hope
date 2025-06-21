import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/providers/locale_provider.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';

class CustomItem extends StatelessWidget {
  final IconData? iconData;
  final Widget? customIcon;
  final bool language;
  final String title;
  final ThemeProvider themeProvider;
  final LocaleProvider localeProvider;
  final VoidCallback? onTap;

  const CustomItem({
    Key? key,
    this.iconData,
    this.customIcon,
    this.language = false,
    required this.title,
    required this.themeProvider,
    required this.localeProvider,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    final iconWidget = customIcon ??
        (iconData != null
            ? Icon(iconData, color: AppColors.Teal, size: 20)
            : null);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: InkWell(
        onTap: () {
          print('Tapped!');
          if (language) {
            localeProvider.locale = localeProvider.locale == 'en' ? 'ar' : 'en';
          } else {
            themeProvider.themeMode =
                themeProvider.isDark() ? ThemeMode.light : ThemeMode.dark;
          }
        },
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.lavender,
              radius: 20,
              child: FittedBox(child: iconWidget),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const Spacer(),
            language
                ? Text(
                    localeProvider.locale == 'en'
                        ? appLocalizations.en
                        : appLocalizations.ar,
                    style: const TextStyle(
                      color: AppColors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    themeProvider.isDark()
                        ? appLocalizations.dark
                        : appLocalizations.light,
                    style: TextStyle(
                      color: AppColors.yellow,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
