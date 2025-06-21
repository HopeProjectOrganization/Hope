import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/main.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class AdminHealthyEditorScreen extends StatefulWidget {
  static const String routeName = '/adminHealthEditor';
  final Map<String, dynamic>? newsData;

  const AdminHealthyEditorScreen({Key? key, this.newsData}) : super(key: key);

  @override
  State<AdminHealthyEditorScreen> createState() =>
      _AdminHealthyEditorScreenState();
}

class _AdminHealthyEditorScreenState extends State<AdminHealthyEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  File? _pickedImage;
  String? _existingImageUrl;
  String? _category;
  late String _date;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    final now = DateTime.now();
    _date = "${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (widget.newsData != null) {
        _titleController.text = widget.newsData!['title'] ?? '';
        _descriptionController.text = widget.newsData!['description'] ?? '';
        _existingImageUrl = widget.newsData!['imageUrl'];
        _category = widget.newsData!['category'];
      } else if (args != null) {
        _category = args['category'] ?? '';
      }
    });
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref =
          FirebaseStorage.instance.ref().child('diet_images/$fileName.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _saveNews() async {
    if (!_formKey.currentState!.validate()) return;

    String imageUrl = _existingImageUrl ?? '';
    if (_pickedImage != null) {
      final uploadedUrl = await _uploadImageToFirebase(_pickedImage!);
      if (uploadedUrl != null) {
        imageUrl = uploadedUrl;
      }
    }

    // ✨ تنظيف الـ title والـ description
    String cleanedTitle = _titleController.text.trim();
    String cleanedDescription = _descriptionController.text
        .replaceAll(RegExp(r'\n\s*\n+'), '\n\n') // إزالة الأسطر الفاضية الزايدة
        .replaceAll(RegExp(r'[ \t]{2,}'), ' ') // إزالة المسافات الزايدة
        .trim();

    final newsItem = {
      'title': cleanedTitle,
      'description': cleanedDescription,
      'imageUrl': imageUrl,
      'category': _category,
      'date': _date,
    };

    final url = widget.newsData != null
        ? 'http://${MyApp.IP}/api/diet/edit/${widget.newsData!['id']}'
        : 'http://${MyApp.IP}/api/diet';

    try {
      final response = await (widget.newsData != null
          ? http.put(Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(newsItem))
          : http.post(Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(newsItem)));

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.newsData != null
              ? 'Article updated successfully!'
              : 'Article added successfully!'),
        ));
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.newsData != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Diet Article' : 'Add Diet Article'),
        backgroundColor: AppColors.Teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Description is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _category ?? '',
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                color: AppColors.lavender,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: TextButton.icon(
                          onPressed: _pickImage,
                          icon:
                              const Icon(Icons.image, color: Colors.deepPurple),
                          label: const Text(
                            'Pick Image from Gallery',
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_pickedImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _pickedImage!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else if (_existingImageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _existingImageUrl!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: _pickImage,
                          child: SizedBox(
                            height: 200,
                            child: Center(
                              child: Lottie.asset(
                                'assets/lottie/imagePicker.json',
                                repeat: true,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                onClick: _saveNews,
                color: AppColors.Teal,
                title: isEdit ? 'Update Article' : 'Add Article',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
