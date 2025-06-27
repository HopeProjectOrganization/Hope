import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hope/Api/healthy_diet/exercises_service.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/model/exercises.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';

class AdminAddExerciseScreen extends StatefulWidget {
  final Exercise? exercise;
  final String bodyPart;

  const AdminAddExerciseScreen(
      {super.key, this.exercise, required this.bodyPart});

  @override
  State<AdminAddExerciseScreen> createState() => _AdminAddExerciseScreenState();
}

class _AdminAddExerciseScreenState extends State<AdminAddExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bodyPartController = TextEditingController();
  final TextEditingController gifUrlController = TextEditingController();
  final TextEditingController equipmentController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController exercsiseIdController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController secondaryMusclesController =
      TextEditingController();

  bool isSaving = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.exercise != null) {
      final ex = widget.exercise!;
      nameController.text = ex.name;
      gifUrlController.text = ex.gifUrl;
      equipmentController.text = ex.equipment;
      targetController.text = ex.target;
      exercsiseIdController.text = ex.excersiesId;
      bodyPartController.text = ex.bodyPart;
      instructionsController.text = ex.instructions.join('\n');
      secondaryMusclesController.text = ex.secondaryMuscles.join('\n');
    } else {
      bodyPartController.text = widget.bodyPart;
    }
  }

  Future<String?> pickAndUploadImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;

    setState(() => isSaving = true);
    final file = File(picked.path);
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child('exercises/$fileName.jpg');

    try {
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      setState(() {
        _selectedImage = file;
        gifUrlController.text = url;
      });
      return url;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Upload error: $e")));
      return null;
    } finally {
      setState(() => isSaving = false);
    }
  }

  Future<void> saveExercise() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isSaving = true);

    final exercise = Exercise(
      id: widget.exercise?.id ?? 0,
      excersiesId: exercsiseIdController.text.trim(),
      name: nameController.text.trim(),
      bodyPart: bodyPartController.text.trim(),
      gifUrl: gifUrlController.text.trim(),
      equipment: equipmentController.text.trim(),
      target: targetController.text.trim(),
      secondaryMuscles: secondaryMusclesController.text
          .trim()
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .toList(),
      instructions: instructionsController.text
          .trim()
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .toList(),
    );

    try {
      if (widget.exercise == null) {
        await ExerciseApiService().createExercise(exercise);
      } else {
        await ExerciseApiService().updateExercise(exercise.id!, exercise);
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving exercise: $e")),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  Widget buildTextField(TextEditingController controller, String label,
      {bool multiLine = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        validator: (value) => value!.isEmpty ? 'Required' : null,
        keyboardType: multiLine ? TextInputType.multiline : TextInputType.text,
        maxLines: multiLine ? null : 1,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          fillColor: AppColors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget buildImagePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Exercise Image", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: pickAndUploadImage,
          child: _selectedImage != null
              ? Image.file(_selectedImage!, height: 150)
              : gifUrlController.text.isNotEmpty
                  ? Image.network(gifUrlController.text, height: 150)
                  : Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.add_a_photo)),
                    ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: gifUrlController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Image URL (auto-filled)",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.exercise != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Exercise" : "Add Exercise")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: bodyPartController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Body Part",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              buildTextField(exercsiseIdController, "Exercise ID"),
              buildTextField(nameController, "Exercise Name"),
              buildTextField(equipmentController, "Equipment"),
              buildTextField(targetController, "Target"),
              buildTextField(
                  instructionsController, "Instructions (one per line)",
                  multiLine: true),
              buildTextField(secondaryMusclesController,
                  "Secondary Muscles (one per line)",
                  multiLine: true),
              const SizedBox(height: 8),
              buildImagePickerField(),
              const SizedBox(height: 20),
              CustomButton(
                title: isSaving
                    ? "Saving..."
                    : isEdit
                        ? "Update"
                        : "Save",
                onClick: isSaving ? () {} : saveExercise,
              )
            ],
          ),
        ),
      ),
    );
  }
}
