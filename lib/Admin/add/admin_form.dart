import 'package:flutter/material.dart';
import 'package:hope/Admin/add/admin_product_screen.dart';
import 'package:hope/Api/add/admin_add_service.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/l10n/app_localizations.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';

class AdminAddEditProductScreen extends StatefulWidget {
  final GroupedProduct? groupedProduct;

  const AdminAddEditProductScreen({super.key, this.groupedProduct});

  @override
  State<AdminAddEditProductScreen> createState() =>
      _AdminAddEditProductScreenState();
}

class _AdminAddEditProductScreenState extends State<AdminAddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final barcodeController = TextEditingController();
  final typeController = TextEditingController();

  final List<TextEditingController> ingredientControllers = [];
  final List<TextEditingController> percentageControllers = [];
  final List<int?> ingredientIds = [];

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.groupedProduct != null) {
      nameController.text = widget.groupedProduct!.productName;
      barcodeController.text = widget.groupedProduct!.barcode;
      typeController.text = widget.groupedProduct!.productType;

      for (var entry in widget.groupedProduct!.ingredients) {
        ingredientControllers
            .add(TextEditingController(text: entry.ingredientName));
        percentageControllers
            .add(TextEditingController(text: entry.percentage));
        ingredientIds.add(entry.id);
      }
    } else {
      addIngredientField();
    }
  }

  void addIngredientField() {
    ingredientControllers.add(TextEditingController());
    percentageControllers.add(TextEditingController());
    ingredientIds.add(null);
    setState(() {});
  }

  void removeIngredientField(int index) {
    ingredientControllers.removeAt(index);
    percentageControllers.removeAt(index);
    ingredientIds.removeAt(index);
    setState(() {});
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isSaving = true);

    final ingredients = <Map<String, String>>[];

    for (int i = 0; i < ingredientControllers.length; i++) {
      final ingredientName = ingredientControllers[i].text;
      final percentage = percentageControllers[i].text;

      ingredients.add({
        "ingredientName": ingredientName,
        "percentage": percentage,
      });

      if (widget.groupedProduct != null && ingredientIds[i] != null) {
        final updateData = {
          "product": {
            "productName": nameController.text,
            "barcode": barcodeController.text,
            "productType": typeController.text,
          },
          "ingredient": {
            "ingredientName": ingredientName,
            "percentage": percentage,
          },
        };
        await ProductService()
            .updateProductFromMap(ingredientIds[i]!, updateData);
      }
    }

    final fullData = {
      "product": {
        "productName": nameController.text,
        "barcode": barcodeController.text,
        "productType": typeController.text,
      },
      "ingredients": ingredients,
    };

    try {
      if (widget.groupedProduct == null) {
        await ProductService().addProductFromMap(fullData);
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("❌ ${AppLocalizations.of(context)!.errorUpdate}")));
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppColors.Teal,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(widget.groupedProduct == null
              ? appLoc.addProduct
              : appLoc.editProduct)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildField(nameController, appLoc.productName),
              buildField(barcodeController, appLoc.barcode),
              buildField(typeController, appLoc.productType),
              const SizedBox(height: 16),
              Text(appLoc.ingredients,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ingredientControllers.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                          child: buildField(ingredientControllers[index],
                              appLoc.ingredientName)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: buildField(
                              percentageControllers[index], appLoc.percentage)),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeIngredientField(index),
                      ),
                    ],
                  );
                },
              ),
              TextButton.icon(
                onPressed: addIngredientField,
                icon: const Icon(Icons.add),
                label: Text(appLoc.addIngredient),
              ),
              const SizedBox(height: 20),
              CustomButton(
                title: appLoc.save,
                onClick: isSaving ? () {} : save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        validator: (value) => value == null || value.isEmpty
            ? AppLocalizations.of(context)!.required
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
