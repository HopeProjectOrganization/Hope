import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/assets/app_assets.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/ui/shared_widgets/language_switch.dart';
import 'package:hope/ui/shared_widgets/theme_switch.dart';
import 'package:provider/provider.dart';

class MenuTab extends StatefulWidget {
  const MenuTab({super.key});

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations =
        AppLocalizations.of(context) ?? AppLocalizations.of(context)!;
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            appLocalizations.language,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          LanguageSwitch()
        ],
      ),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            appLocalizations.theme,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          ThemeSwitch(),
        ],
      ),
    ]);
    SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
              decoration: const BoxDecoration(
                color: AppColors.purple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(64),
                ),
              ),
              child: Row(children: [
                ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomLeft: Radius.circular(1000),
                      bottomRight: Radius.circular(1000),
                      topRight: Radius.circular(1000),
                    ),
                    child: Image.asset(
                      AppAssets.login,
                      fit: BoxFit.cover,
                      width: 124,
                      height: 124,
                    )),
                const SizedBox(
                  width: 16,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'user',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'user@gmail.com',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              ])),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Language',
              style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    bottomSheet();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.purple, width: 2),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'English',
                          style: TextStyle(
                              color: AppColors.purple,
                              fontWeight: FontWeight.w700,
                              fontSize: 24),
                        ),
                        Icon(
                          Icons.arrow_drop_down_sharp,
                          color: AppColors.purple,
                          size: 34,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Theme',
              style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    bottomSheet();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.purple, width: 2),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Light',
                          style: TextStyle(
                              color: AppColors.purple,
                              fontWeight: FontWeight.w700,
                              fontSize: 24),
                        ),
                        Icon(
                          Icons.arrow_drop_down_sharp,
                          color: AppColors.purple,
                          size: 34,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: AppColors.white,
                      size: 34,
                    ),
                    Text(
                      'Log out',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              )),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }

  void bottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(),
    );
  }
}
