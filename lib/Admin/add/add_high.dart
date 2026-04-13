import 'package:flutter/material.dart';
import 'package:hope/Api/add/high_ingredients.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/model/high_risk_ingredents.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:hope/core/providers/theme_provider.dart';

class AddHighIngredientScreen extends StatefulWidget {
  final HighRiskIngredient? ingredient;

  const AddHighIngredientScreen({super.key, this.ingredient});

  @override
  State<AddHighIngredientScreen> createState() =>
      _AddHighIngredientScreenState();
}

class _AddHighIngredientScreenState extends State<AddHighIngredientScreen> {
  final nameController = TextEditingController();
  final levelController = TextEditingController();
  final safeLimitController = TextEditingController();
  final enDescController = TextEditingController();
  final arDescController = TextEditingController();
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  final _formKey = GlobalKey<FormState>();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.ingredient != null) {
      nameController.text = widget.ingredient!.ingredientName;
      levelController.text = widget.ingredient!.riskLevel;
      safeLimitController.text = widget.ingredient!.safeLimit;
      enDescController.text = widget.ingredient!.englishDescription;
      arDescController.text = widget.ingredient!.arabicDescription;
    }
  }

  Future<void> saveIngredient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    final model = HighRiskIngredient(
      id: widget.ingredient?.id,
      ingredientName: nameController.text.trim(),
      riskLevel: levelController.text.trim(),
      safeLimit: safeLimitController.text.trim(),
      englishDescription: enDescController.text.trim(),
      arabicDescription: arDescController.text.trim(),
    );

    try {
      if (widget.ingredient == null) {
        await HighRiskIngredientService.create(model);
      } else {
        await HighRiskIngredientService.update(widget.ingredient!.id!, model);
      }
      Navigator.pop(context, true);
    } catch (e) {
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.ingredient == null
              ? appLocalizations.addIngredient
              : appLocalizations.editIngredient,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildField(nameController, appLocalizations.ingredientName),
              buildField(levelController, appLocalizations.riskLevel),
              buildField(safeLimitController, appLocalizations.safeLimit),
              buildField(enDescController, appLocalizations.englishDescription,
                  maxLines: 3),
              buildField(arDescController, appLocalizations.arabicDescription,
                  maxLines: 3),
              const SizedBox(height: 24),
              CustomButton(
                title: appLocalizations.save,
                onClick: isSaving ? () {} : saveIngredient,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (val) => val == null || val.trim().isEmpty
            ? appLocalizations.requiredField
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
