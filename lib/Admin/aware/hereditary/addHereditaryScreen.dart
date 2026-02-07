// AdminHereditaryEditorScreen adapted to match the Article model
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/main.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminHereditaryEditorScreen extends StatefulWidget {
  static const routeName = '/adminHereditaryEditor';

  const AdminHereditaryEditorScreen();

  @override
  State<AdminHereditaryEditorScreen> createState() =>
      _AdminHereditaryEditorScreenState();
}

class _AdminHereditaryEditorScreenState
    extends State<AdminHereditaryEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _article = {};
  File? _pickedImage;
  String? _existingImageUrl;
  int? _articleId;
  String _category = 'BREAST';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (data != null) {
      _article.addAll(data);
      _articleId = data['id'];
      _existingImageUrl = data['imageUrl'];
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _pickedImage = File(pickedFile.path));
    }
  }

  Future<String?> _uploadImage(File file) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('articles/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Image upload error: $e");
      return null;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    _article['category'] = _category; // ✅ ضيفي دا هنا

    if (_pickedImage != null) {
      final imageUrl = await _uploadImage(_pickedImage!);
      _article['imageUrl'] = imageUrl;
    } else if (_existingImageUrl != null) {
      _article['imageUrl'] = _existingImageUrl;
    }

    final url = Uri.parse(
      _articleId != null
          ? 'http://${MyApp.IP}/api/hereditary/$_articleId'
          : 'http://${MyApp.IP}/api/hereditary',
    );

    final response = await (_articleId != null
        ? http.put(url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(_article))
        : http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(_article)));

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_articleId != null
                ? 'Updated successfully'
                : 'Added successfully')),
      );
      Navigator.pop(context, true); // يرجّع قيمة تدل على نجاح التعديل
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_articleId != null ? 'Edit Article' : 'Add Article')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _category,
                onChanged: (val) => setState(() => _category = val!),
                items:
                    ["BREAST", "OVARIAN", "PROSTATE", "MELANOMA", "PANCREATIC"]
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                        .toList(),
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: const TextStyle(color: AppColors.Teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.Teal),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.Teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppColors.gray, width: 2),
                  ),
                ),
                dropdownColor: AppColors.white,
                iconEnabledColor: AppColors.Teal,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              _buildField('title', required: true),
              _buildField('articleId'),
              _buildField('description'),
              _buildField('content'),
              _buildField('link'),
              _buildField('creator'),
              _buildField('pubDate'),
              _buildField('sourceName'),
              _buildField('sourceUrl'),
              _buildField('sourceIcon'),
              const SizedBox(height: 12),
              if (_pickedImage != null)
                Image.file(_pickedImage!, height: 150)
              else if (_existingImageUrl != null)
                Image.network(_existingImageUrl!, height: 150),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Pick Image"),
              ),
              const SizedBox(height: 16),
              CustomButton(
                title: _articleId != null ? 'Update' : 'Submit',
                onClick: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String key,
      {bool required = false, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: _article[key]?.toString() ?? '',
        decoration: InputDecoration(
          labelText: key.capitalize(),
          labelStyle: const TextStyle(color: AppColors.gray),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.gray),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.gray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.gray, width: 2),
          ),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        onSaved: (val) {
          if (val != null) {
            if (key == 'creator') {
              _article[key] = val.split(',').map((e) => e.trim()).toList();
            } else if (isNumber) {
              _article[key] = int.tryParse(val);
            } else {
              _article[key] = val;
            }
          }
        },
        validator: (val) =>
            required && (val == null || val.isEmpty) ? 'Required' : null,
      ),
    );
  }
}

extension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
