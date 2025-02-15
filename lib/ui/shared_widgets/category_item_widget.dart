import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';

class CategoryItemWidget extends StatelessWidget {
  const CategoryItemWidget(
      {super.key,
      required this.title,
      required this.image,
      required this.index,
      this.onTap});

  final String image;

  final int index;
  final void Function()? onTap;

  final String title;

  @override
  Widget build(BuildContext context) {
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
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark),
                ),
              ],
            ),
            Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: AppColors.white.withOpacity(.5)),
                  child: const FittedBox(
                    child: Row(
                      children: [
                        Text('View all'),
                        SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                            backgroundColor: AppColors.white,
                            child: Icon(Icons.arrow_forward_ios_rounded))
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
