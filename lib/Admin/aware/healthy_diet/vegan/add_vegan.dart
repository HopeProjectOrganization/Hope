import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hope/Api/healthy_diet/vegan_service.dart';
import 'package:hope/model/vegan_details.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';

class AddVeganRecipeScreen extends StatefulWidget {
  static const routeName = '/AddVeganRecipe';

  const AddVeganRecipeScreen({super.key});

  @override
  State<AddVeganRecipeScreen> createState() => _AddVeganRecipeScreenState();
}

class _AddVeganRecipeScreenState extends State<AddVeganRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _difficultyController = TextEditingController();
  final _portionController = TextEditingController();
  final _timeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController(); // comma separated
  final _stepsController = TextEditingController(); // use | to separate steps

  File? _imageFile;
  String? _uploadedImageUrl;

  bool _isLoading = false;

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
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      _uploadedImageUrl = await _uploadImage(_imageFile!);

      final recipe = VeganRecipeModel(
        veganId: _idController.text,
        title: _titleController.text,
        image: _uploadedImageUrl!,
        time: _timeController.text,
        portion: _portionController.text,
        difficulty: _difficultyController.text,
        description: _descriptionController.text,
        ingredients: _ingredientsController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
        steps: _stepsController.text
            .split('|')
            .asMap()
            .entries
            .map((entry) => StepModel(
                  stepTitle: 'Step ${entry.key + 1}',
                  stepDescription: entry.value.trim(),
                ))
            .toList(),
      );

      await VeganRecipeService.createRecipe(recipe);
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
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
    return Scaffold(
      appBar: AppBar(title: const Text("Add Vegan Recipe")),
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
                              child: const Center(
                                child: Text("Tap to select image"),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    _buildField(_idController, "Vegan ID"),
                    _buildField(_titleController, "Title"),
                    _buildField(_difficultyController, "Difficulty"),
                    _buildField(_portionController, "Portion"),
                    _buildField(_timeController, "Preparation Time"),
                    _buildField(_descriptionController, "Description",
                        maxLines: 3),
                    _buildField(
                        _ingredientsController, "Ingredients (comma-separated)",
                        maxLines: 3),
                    _buildField(_stepsController, "Steps (use | between steps)",
                        maxLines: 4),
                    const SizedBox(height: 20),
                    CustomButton(
                      title: "Add Recipe",
                      onClick: _submitForm,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
