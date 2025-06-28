import 'package:flutter/material.dart';
import 'package:hope/Api/add/high_ingredients.dart';
import 'package:hope/model/high_risk_ingredents.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';

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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.ingredient == null ? "Add Ingredient" : "Edit Ingredient"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildField(nameController, "Ingredient Name"),
              buildField(levelController, "Risk Level"),
              buildField(safeLimitController, "Safe Limit"),
              buildField(enDescController, "English Description", maxLines: 3),
              buildField(arDescController, "Arabic Description", maxLines: 3),
              const SizedBox(height: 24),
              CustomButton(
                title: 'Save',
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
        validator: (val) =>
            val == null || val.trim().isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
