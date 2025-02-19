import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

class CategoryItemWidget extends StatelessWidget {
  CategoryItemWidget(
      {super.key,
      required this.title,
      required this.image,
      required this.index,
      this.onTap});

  final String image;

  final int index;
  final void Function()? onTap;

  late ThemeProvider themeProvider;

  late AppLocalizations appLocalizations;

  final String title;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations =
        AppLocalizations.of(context) ?? AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height * 0.23,
      decoration: const BoxDecoration(
          color: AppColors.lavender,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: AlignmentDirectional.bottomEnd,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Image.asset(image),
                  ),
                ]),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 40,
                        height: 1,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark),
                  ),
                )
              ],
            ),
            Positioned(
                bottom: 10,
                right: Localizations.localeOf(context).languageCode == 'ar'
                    ? 10
                    : null,
                left: Localizations.localeOf(context).languageCode == 'ar'
                    ? null
                    : 10,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: (themeProvider.isDark()
                              ? AppColors.dark
                              : AppColors.white)
                          .withOpacity(.5)),
                  child: FittedBox(
                    child: Row(
                      children: [
                        Text(appLocalizations.viewAll),
                        const SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                            backgroundColor: themeProvider.isDark()
                                ? AppColors.dark
                                : AppColors.white,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: themeProvider.isDark()
                                  ? AppColors.white
                                  : AppColors.dark,
                            ))
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
