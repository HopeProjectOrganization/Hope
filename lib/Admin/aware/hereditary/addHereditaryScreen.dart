// AdminHereditaryEditorScreen adapted to match the Article model
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hope/main.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminHereditaryEditorScreen extends StatefulWidget {
  static const routeName = '/adminHereditaryEditor';
  final Map<String, dynamic>? articleData;

  const AdminHereditaryEditorScreen({Key? key, this.articleData})
      : super(key: key);

  @override
  State<AdminHereditaryEditorScreen> createState() =>
      _AdminHereditaryEditorScreenState();
}

class _AdminHereditaryEditorScreenState
    extends State<AdminHereditaryEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'articleId': TextEditingController(),
    'title': TextEditingController(),
    'link': TextEditingController(),
    'description': TextEditingController(),
    'content': TextEditingController(),
    'pubDate': TextEditingController(),
    'sourceId': TextEditingController(),
    'sourceName': TextEditingController(),
    'sourceUrl': TextEditingController(),
    'sourcePriority': TextEditingController(),
    'language': TextEditingController(),
    'category': TextEditingController(),
  };

  final TextEditingController keywordsController = TextEditingController();
  final TextEditingController creatorController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController videoUrlController = TextEditingController();
  final TextEditingController sourceIconController = TextEditingController();
  bool duplicate = false;

  File? _pickedImage;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.articleData != null) {
      final data = widget.articleData!;
      controllers.forEach((key, controller) {
        controller.text = data[key]?.toString() ?? '';
      });
      keywordsController.text =
          (data['keywords'] as List<dynamic>?)?.join(', ') ?? '';
      creatorController.text =
          (data['creator'] as List<dynamic>?)?.join(', ') ?? '';
      countryController.text =
          (data['country'] as List<dynamic>?)?.join(', ') ?? '';
      videoUrlController.text = data['videoUrl'] ?? '';
      sourceIconController.text = data['sourceIcon'] ?? '';
      duplicate = data['duplicate'] ?? false;
      _existingImageUrl = data['imageUrl'];
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref =
          FirebaseStorage.instance.ref().child('articles/$fileName.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Image upload error: $e');
      return null;
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    String imageUrl = _existingImageUrl ?? '';
    if (_pickedImage != null) {
      final uploadedUrl = await _uploadImage(_pickedImage!);
      if (uploadedUrl != null) imageUrl = uploadedUrl;
    }

    final article = {
      ...controllers.map((k, v) => MapEntry(k, v.text)),
      'keywords':
          keywordsController.text.split(',').map((e) => e.trim()).toList(),
      'creator':
          creatorController.text.split(',').map((e) => e.trim()).toList(),
      'country':
          countryController.text.split(',').map((e) => e.trim()).toList(),
      'videoUrl': videoUrlController.text,
      'sourceIcon': sourceIconController.text,
      'duplicate': duplicate,
      'imageUrl': imageUrl,
    };

    final isEdit =
        widget.articleData != null && widget.articleData!['id'] != null;
    final id = widget.articleData?['id'];
    final url = isEdit
        ? 'https://${MyApp.IP}/api/hereditary/$id'
        : 'https://${MyApp.IP}/api/hereditary';

    final response = await (isEdit
        ? Uri.parse(url).sendJsonPut(article)
        : Uri.parse(url).sendJsonPost(article));

    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(isEdit ? 'Article updated' : 'Article added')));
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.articleData != null;
    return Scaffold(
      appBar: AppBar(
        title:
            Text(isEdit ? 'Edit Hereditary Article' : 'Add Hereditary Article'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...controllers.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: entry.value,
                    decoration:
                        InputDecoration(labelText: entry.key.capitalize()),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Required' : null,
                  ),
                )),
            TextFormField(
              controller: keywordsController,
              decoration: const InputDecoration(
                  labelText: 'Keywords (comma-separated)'),
            ),
            TextFormField(
              controller: creatorController,
              decoration: const InputDecoration(
                  labelText: 'Creator(s) (comma-separated)'),
            ),
            TextFormField(
              controller: countryController,
              decoration:
                  const InputDecoration(labelText: 'Country (comma-separated)'),
            ),
            TextFormField(
              controller: videoUrlController,
              decoration: const InputDecoration(labelText: 'Video URL'),
            ),
            TextFormField(
              controller: sourceIconController,
              decoration: const InputDecoration(labelText: 'Source Icon URL'),
            ),
            SwitchListTile(
              value: duplicate,
              onChanged: (val) => setState(() => duplicate = val),
              title: const Text('Duplicate'),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              label: const Text("Pick Image"),
              onPressed: _pickImage,
            ),
            if (_pickedImage != null)
              Image.file(_pickedImage!, height: 150, fit: BoxFit.cover)
            else if (_existingImageUrl != null)
              Image.network(_existingImageUrl!, height: 150, fit: BoxFit.cover),
            const SizedBox(height: 20),
            CustomButton(
                title: isEdit ? 'Update Article' : 'Add Article',
                onClick: _submit),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

extension UriExtension on Uri {
  Future<bool> sendJsonPost(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        this,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendJsonPut(Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        this,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
