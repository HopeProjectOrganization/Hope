import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/core/theme/app_colors.dart';

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  static const routeName = '/adminProducts';

  @override
  Widget build(BuildContext context) {
    late AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.products)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProductCard(
              title: appLocalizations.addProducts,
              icon: Icons.shopping_bag,
              color: AppColors.Teal,
              onTap: () => Navigator.pushNamed(context, '/adminAdd'),
            ),
            const SizedBox(height: 16),
            ProductCard(
              title: appLocalizations.addHighRiskIngredients,
              icon: Icons.warning_amber,
              color: AppColors.Teal,
              onTap: () => Navigator.pushNamed(context, '/addHighIngredient'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: color.withOpacity(0.2),
        child: Ink(
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          height: MediaQuery.of(context).size.height * .2,
          width: double.infinity,
          child: Row(
            children: [
              const SizedBox(width: 20),
              CircleAvatar(
                radius: 35,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, color: color, size: 40),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // ➡️ السهم داخل دايرة
              Container(
                margin: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.9),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: AppColors.yellow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
