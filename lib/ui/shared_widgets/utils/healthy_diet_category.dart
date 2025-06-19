import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HealthyDietCategory extends StatelessWidget {
  HealthyDietCategory(
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
    return InkWell(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.37,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: themeProvider.isDark() ? AppColors.dark : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.purple,
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // النص داخل مستطيل أخضر
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.cloudi,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                title, style: Theme.of(context).textTheme.labelLarge),
            ),
            const SizedBox(height: 16),
            // الأيقونة والرسم
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: Container()),
                Expanded(
                    flex: 3,
                    child: Image.asset(
                      image,
                    )),
              ],
            ),
            Spacer(),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.yellow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.north_east,
                size: 18,
                color: AppColors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
