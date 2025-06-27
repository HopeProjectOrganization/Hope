import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hope/Api/recipes/recipe_service.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:hope/model/meal_dm.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddMeal extends StatefulWidget {
  static const routeName = '/AddMeal';

  const AddMeal({super.key});

  @override
  State<AddMeal> createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;

  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prepareTimeController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _servingsController = TextEditingController();
  final _tagsController = TextEditingController();
  final _ingredientsController =
      TextEditingController(); // ingredient1:unit:desc:qty:grams:scale,...
  final _stepsController = TextEditingController(); // step1|step2|step3
  final _caloriesController = TextEditingController();
  final _netCarbsController = TextEditingController();
  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();

  File? _imageFile;
  String? _uploadedImageUrl;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<String> _uploadImage(File image) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child('meals/$fileName.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      _uploadedImageUrl = await _uploadImage(_imageFile!);

      final meal = Meal(
        id: _idController.text,
        name: _nameController.text,
        description: _descriptionController.text,
        image: _uploadedImageUrl!,
        prepareTime: int.tryParse(_prepareTimeController.text) ?? 0,
        cookTime: int.tryParse(_cookTimeController.text) ?? 0,
        servings: int.tryParse(_servingsController.text) ?? 1,
        tags: _tagsController.text.split(',').map((e) => e.trim()).toList(),
        steps: _stepsController.text.split('|').map((e) => e.trim()).toList(),
        ingredients: _parseIngredients(_ingredientsController.text),
        nutrients: Nutrients(
          calories: double.tryParse(_caloriesController.text) ?? 0,
          netCarbs: double.tryParse(_netCarbsController.text) ?? 0,
          protein: double.tryParse(_proteinController.text) ?? 0,
          fat: double.tryParse(_fatController.text) ?? 0,
        ),
      );
      await MealApiService().saveMeal(meal);

      Navigator.pop(context);
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Ingredient> _parseIngredients(String input) {
    return input.split(',').map((line) {
      final parts = line.trim().split(':');
      return Ingredient(
        name: parts[0],
        servingSize: ServingSize(
          units: parts.length > 1 ? parts[1] : '',
          desc: parts.length > 2 ? parts[2] : '',
          qty: parts.length > 3 ? double.tryParse(parts[3]) ?? 0 : 0,
          grams: parts.length > 4 ? double.tryParse(parts[4]) ?? 0 : null,
          scale: parts.length > 5 ? double.tryParse(parts[5]) ?? 1.0 : 1.0,
        ),
      );
    }).toList();
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
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    late ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    late AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.addMeal)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
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
                          : Container(
                              height: 180,
                              color: Colors.grey[300],
                              child: Center(
                                child: Text(appLocalizations.tapToSelectImage),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    _buildField(_idController, "ID"),
                    _buildField(_nameController, appLocalizations.mealName),
                    _buildField(
                        _descriptionController, appLocalizations.description,
                        maxLines: 3),
                    _buildField(
                        _prepareTimeController, appLocalizations.prepareTime),
                    _buildField(_cookTimeController, appLocalizations.cookTime),
                    _buildField(_servingsController, appLocalizations.servings),
                    _buildField(_ingredientsController,
                        appLocalizations.ingredientsComma,
                        maxLines: 3),
                    _buildField(_stepsController, appLocalizations.mealSteps,
                        maxLines: 3),
                    const Divider(),
                    _buildField(_caloriesController, appLocalizations.calories),
                    _buildField(_netCarbsController, appLocalizations.carbs),
                    _buildField(_proteinController, appLocalizations.protein),
                    _buildField(_fatController, appLocalizations.fat),
                    const SizedBox(height: 20),
                    CustomButton(
                      onClick: _submitForm,
                      title: appLocalizations.addMeal,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
