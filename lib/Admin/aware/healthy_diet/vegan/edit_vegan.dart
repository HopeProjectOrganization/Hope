import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hope/Api/healthy_diet/vegan_service.dart';
import 'package:hope/model/vegan_details.dart';
import 'package:image_picker/image_picker.dart';

class EditVeganRecipeScreen extends StatefulWidget {
  static const routeName = '/EditVeganRecipe';
  final VeganRecipeModel recipe;

  const EditVeganRecipeScreen({super.key, required this.recipe});

  @override
  State<EditVeganRecipeScreen> createState() => _EditVeganRecipeScreenState();
}

class _EditVeganRecipeScreenState extends State<EditVeganRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _timeController;
  late TextEditingController _portionController;
  late TextEditingController _difficultyController;
  late TextEditingController _descriptionController;
  late TextEditingController _ingredientsController;
  late TextEditingController _stepsController;

  File? _imageFile;
  String? _imageUrl;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final recipe = widget.recipe;

    _titleController = TextEditingController(text: recipe.title);
    _timeController = TextEditingController(text: recipe.time);
    _portionController = TextEditingController(text: recipe.portion);
    _difficultyController = TextEditingController(text: recipe.difficulty);
    _descriptionController = TextEditingController(text: recipe.description);
    _ingredientsController =
        TextEditingController(text: recipe.ingredients.join(','));
    _stepsController = TextEditingController(
        text: recipe.steps.map((e) => e.stepDescription).join(' | '));
    _imageUrl = recipe.image;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref =
        FirebaseStorage.instance.ref().child('vegan_recipes/$fileName.jpg');

    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // If user picked a new image, upload it
      if (_imageFile != null) {
        _imageUrl = await _uploadImage(_imageFile!);
      }

      final updatedRecipe = VeganRecipeModel(
        veganId: widget.recipe.veganId,
        title: _titleController.text,
        image: _imageUrl!,
        time: _timeController.text,
        portion: _portionController.text,
        difficulty: _difficultyController.text,
        description: _descriptionController.text,
        ingredients: _ingredientsController.text.split(','),
        steps: _stepsController.text
            .split('|')
            .map((s) => StepModel(stepTitle: 'Step', stepDescription: s.trim()))
            .toList(),
      );

      await VeganRecipeService.updateByVeganId(
          widget.recipe.veganId, updatedRecipe);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong while updating.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Vegan Recipe")),
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
                          : Image.network(_imageUrl!, height: 180),
                    ),
                    const SizedBox(height: 16),
                    _buildField(_titleController, "Title"),
                    _buildField(_timeController, "Preparation Time"),
                    _buildField(_portionController, "Portion"),
                    _buildField(_difficultyController, "Difficulty"),
                    _buildField(_descriptionController, "Description",
                        maxLines: 3),
                    _buildField(
                        _ingredientsController, "Ingredients (comma-separated)",
                        maxLines: 3),
                    _buildField(_stepsController, "Steps (use | between steps)",
                        maxLines: 3),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text("Update Recipe"),
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
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
