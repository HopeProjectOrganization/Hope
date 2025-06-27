import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hope/Api/healthy_diet/healthy_recipe_service.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/healthy_recipes.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';

class AdminMealFormScreen extends StatefulWidget {
  final RecipeModel? meal;

  const AdminMealFormScreen({super.key, this.meal});

  @override
  State<AdminMealFormScreen> createState() => _AdminMealFormScreenState();
}

class _AdminMealFormScreenState extends State<AdminMealFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController recipeIdController = TextEditingController();

  bool isSaving = false;
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.meal != null) {
      nameController.text = widget.meal!.name ?? '';
      areaController.text = widget.meal!.area ?? '';
      imageUrlController.text = widget.meal!.imageUrl ?? '';
      instructionsController.text = widget.meal!.instructions ?? '';
      ingredientsController.text = widget.meal!.ingredients.entries
          .map((e) => "${e.key}:${e.value}")
          .join("\n");
      categoryController.text = widget.meal!.category ?? '';
      recipeIdController.text = widget.meal!.recipeId ?? '';
    }
  }

  Future<void> pickAndUploadImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
      final fileName = 'recipes/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child(fileName);

      try {
        await ref.putFile(_pickedImage!);
        final url = await ref.getDownloadURL();
        setState(() => imageUrlController.text = url);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image uploaded successfully")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: $e")),
        );
      }
    }
  }

  Future<void> saveMeal() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isSaving = true);

    final Map<String, String> ingredients = {};
    for (var line in ingredientsController.text.trim().split('\n')) {
      final parts = line.split(':');
      if (parts.length == 2) {
        ingredients[parts[0].trim()] = parts[1].trim();
      }
    }

    final meal = RecipeModel(
      recipeId: recipeIdController.text.trim(),
      name: nameController.text.trim(),
      area: areaController.text.trim(),
      imageUrl: imageUrlController.text.trim(),
      instructions: instructionsController.text.trim(),
      ingredients: ingredients,
      category: categoryController.text.trim(),
    );

    try {
      if (widget.meal == null) {
        await RecipeService.createRecipe(meal);
      } else {
        // await RecipeService.updateRecipe(meal.recipeId!, meal);
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.meal != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Meal" : "Add Meal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildField(categoryController, "Category"),
              buildField(recipeIdController, "Recipe Id"),
              buildField(nameController, "Name"),
              buildField(areaController, "Area"),

              // زر اختيار ورفع الصورة
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: pickAndUploadImage,
                  icon: const Icon(Icons.upload),
                  label: const Text("Upload Image"),
                ),
              ),

              // عرض الصورة
              if (_pickedImage != null || imageUrlController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _pickedImage != null
                      ? Image.file(_pickedImage!, height: 150)
                      : Image.network(
                          imageUrlController.text,
                          height: 150,
                          errorBuilder: (_, __, ___) =>
                              const Text('Image preview error'),
                        ),
                ),

              buildField(instructionsController, "Instructions", maxLines: 4),
              buildField(
                  ingredientsController, "Ingredients (name:amount per line)",
                  maxLines: 5),

              const SizedBox(height: 20),
              CustomButton(
                title: isSaving
                    ? "Saving..."
                    : isEdit
                        ? "Update"
                        : "Save",
                onClick: isSaving ? () {} : saveMeal,
              )
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
        validator: (value) => value!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          fillColor: AppColors.white,
          filled: true,
        ),
      ),
    );
  }
}
