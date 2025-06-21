import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
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
      margin: const EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height * 0.23,
      decoration: BoxDecoration(
          color: themeProvider.isDark() ? AppColors.dark : AppColors.white,
          // boxShadow: [
          //   BoxShadow(
          //     color: AppColors.gray.withOpacity(0.7), // لون الشادو
          //     spreadRadius: 2, // مدى انتشار الشادو
          //     blurRadius: 5,   // نعومة الشادو
          //     offset: Offset(0, 3), // اتجاه الشادو (أفقي, عمودي)
          //   ),
          // ],
          border: Border.all(
            color: AppColors.Teal, // لون البوردر
            width: 2.0, // سمك البوردر
          ),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      padding: const EdgeInsets.all(10),
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
                        style: Theme.of(context).textTheme.titleLarge))
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
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: AppColors.purple.withOpacity(0.7), // لون الشادو
                      //     spreadRadius: 2, // مدى انتشار الشادو
                      //     blurRadius: 5,   // نعومة الشادو
                      //     offset: Offset(0, 3), // اتجاه الشادو (أفقي, عمودي)
                      //   ),
                      // ],
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.Teal, width: 1),
                      color: AppColors.lavender),
                  child: FittedBox(
                    child: Row(
                      children: [
                        Container(
                          child: CircleAvatar(
                              backgroundColor: AppColors.yellow,
                              radius: 20,
                              child: Container(
                                padding: EdgeInsets.only(left: 12),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: themeProvider.isDark()
                                      ? AppColors.white
                                      : AppColors.dark,
                                ),
                              )),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                              border: Border.all(color: AppColors.dark)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: Text(appLocalizations.viewAll,
                              style: Theme.of(context).textTheme.labelMedium),
                        )
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
