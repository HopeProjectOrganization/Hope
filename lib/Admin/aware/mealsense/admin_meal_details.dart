import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/recipes/recipe_service.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AdminMealDetails extends StatefulWidget {
  static const routeName = '/EditMeal';
  final Meal meal;

  const AdminMealDetails({super.key, required this.meal});

  @override
  State<AdminMealDetails> createState() => _AdminMealDetailsState();
}

class _AdminMealDetailsState extends State<AdminMealDetails> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _prepareTimeController;
  late TextEditingController _cookTimeController;
  late TextEditingController _servingsController;
  late TextEditingController _descriptionController;
  late TextEditingController _ingredientsController;
  late TextEditingController _stepsController;
  late TextEditingController _caloriesController;
  late TextEditingController _carbsController;
  late TextEditingController _proteinController;
  late TextEditingController _fatController;
  late TextEditingController _tagsController;
  late Future<Meal> mealFuture;

  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  File? _imageFile;
  String? _imageUrl;
  bool _isLoading = false;

  void _refreshMeal() {
    setState(() {
      mealFuture = MealApiService().fetchMealById(widget.meal.id);
    });
  }

  @override
  void initState() {
    super.initState();
    final meal = widget.meal;
    _nameController = TextEditingController(text: meal.name);
    _prepareTimeController =
        TextEditingController(text: meal.prepareTime.toString());
    _cookTimeController = TextEditingController(text: meal.cookTime.toString());
    _servingsController = TextEditingController(text: meal.servings.toString());
    _descriptionController = TextEditingController(text: meal.description);
    _ingredientsController = TextEditingController(
        text: meal.ingredients.map((e) => e.name).join(','));
    _stepsController = TextEditingController(text: meal.steps.join(' | '));
    _imageUrl = meal.image;
    _caloriesController =
        TextEditingController(text: widget.meal.nutrients.calories.toString());
    _carbsController =
        TextEditingController(text: widget.meal.nutrients.netCarbs.toString());
    _proteinController =
        TextEditingController(text: widget.meal.nutrients.protein.toString());
    _fatController =
        TextEditingController(text: widget.meal.nutrients.fat.toString());
    _tagsController = TextEditingController(text: widget.meal.tags.join(','));
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final filename = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child("meals/$filename.jpg");
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_imageFile != null) {
        _imageUrl = await _uploadImage(_imageFile!);
      }

      final updatedMeal = widget.meal.copyWith(
        name: _nameController.text,
        image: _imageUrl!,
        prepareTime: int.parse(_prepareTimeController.text),
        cookTime: int.parse(_cookTimeController.text),
        servings: int.parse(_servingsController.text),
        description: _descriptionController.text,
        ingredients: _ingredientsController.text.split(',').map((name) {
          return Ingredient(
            name: name.trim(),
            servingSize: widget.meal.ingredients.first.servingSize,
          );
        }).toList(),
        steps: _stepsController.text.split('|').map((s) => s.trim()).toList(),
        tags: _tagsController.text.split(',').map((t) => t.trim()).toList(),
        nutrients: Nutrients(
          calories: double.parse(_caloriesController.text),
          netCarbs: double.parse(_carbsController.text),
          protein: double.parse(_proteinController.text),
          fat: double.parse(_fatController.text),
        ),
      );

      await MealApiService().updateMeal(updatedMeal.id, updatedMeal);
      _refreshMeal();

      Navigator.pop(context, updatedMeal);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update meal")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    late ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    late AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.editeMeal),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.Teal),
          // ✅ لون الأيقونة
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: _imageFile != null
                          ? Image.file(_imageFile!, height: 180)
                          : Image.network(_imageUrl!, height: 180),
                    ),
                    const SizedBox(height: 16),
                    _buildField(_nameController, appLocalizations.mealName),
                    _buildField(
                        _prepareTimeController, appLocalizations.prepareTime),
                    _buildField(_cookTimeController, appLocalizations.cookTime),
                    _buildField(_servingsController, appLocalizations.servings),
                    _buildField(
                        _descriptionController, appLocalizations.description,
                        maxLines: 3),
                    _buildField(_ingredientsController,
                        appLocalizations.ingredientsComma,
                        maxLines: 2),
                    _buildField(_stepsController, appLocalizations.mealSteps,
                        maxLines: 2),
                    _buildField(_caloriesController, appLocalizations.calories),
                    _buildField(_carbsController, appLocalizations.carbs),
                    _buildField(_proteinController, appLocalizations.protein),
                    _buildField(_fatController, appLocalizations.fat),
                    const SizedBox(height: 20),
                    CustomButton(
                      onClick: _submitForm,
                      title: appLocalizations.updateMeal,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) =>
            value == null || value.isEmpty ? "Required field" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
