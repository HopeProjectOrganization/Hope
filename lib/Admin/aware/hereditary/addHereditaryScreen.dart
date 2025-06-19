import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hope/Admin/utlis/news.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/main.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class AdminHereditaryEditorScreen extends StatefulWidget {
  Map<String, dynamic>? newsData;

  static const String routeName = '/adminHereditaryEditor';

  AdminHereditaryEditorScreen({Key? key, this.newsData}) : super(key: key);

  @override
  State<AdminHereditaryEditorScreen> createState() =>
      _AdminNewsEditorScreenState();
}

class _AdminNewsEditorScreenState extends State<AdminHereditaryEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  String _category = "OVARIAN";
  File? _pickedImage;
  String? _existingImageUrl;


  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _titleController.text = args['title'] ?? '';
          _contentController.text = args['content'] ?? '';
          _category = args['category'] ?? 'OVARIAN';
          _existingImageUrl = args['imageUrl'];
          widget.newsData = args;
        });
      }
    });
  }

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
          FirebaseStorage.instance.ref().child('news_images/$fileName.jpg');
      final downloadUrl = await ref.getDownloadURL();
      print("Image uploaded successfully: $downloadUrl");
      return downloadUrl;
    } on FirebaseException catch (e) {
      print("FirebaseException: ${e.code} - ${e.message}");
      return null;
    } catch (e) {
      print("General Error uploading image: $e");
      return null;
    }
  }

  void _submitNews() async {
    if (!_formKey.currentState!.validate()) return;

    String imageUrl = _existingImageUrl ?? '';

    if (_pickedImage != null) {
      final uploadedUrl = await _uploadImageToFirebase(_pickedImage!);
      if (uploadedUrl != null) {
        imageUrl = uploadedUrl;
      }
    }

    final news = {
      "title": _titleController.text,
      "content": _contentController.text,
      "category": _category,
      "imageUrl": imageUrl,
    };

    final isEdit = widget.newsData != null && widget.newsData!['id'] != null;
    final id = widget.newsData?['id'];
    final url = isEdit
        ? 'http://${MyApp.IP}/api/hereditary/$id'
        : 'http://${MyApp.IP}/api/hereditary';

    final response = await (isEdit ? putNews(news, url) : postNews(news, url));

    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isEdit ? 'News updated' : 'News added'),
      ));
      Navigator.pop(context, true);
    }
  }

  Future<bool> postNews(Map<String, dynamic> data, String url) async {
    return await Uri.parse(url).sendJsonPost(data);
  }

  Future<bool> putNews(Map<String, dynamic> data, String url) async {
    return await Uri.parse(url).sendJsonPut(data);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.newsData != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit News' : 'Add News')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _category,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _category = val);
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Category',
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(),
                ),
                dropdownColor: AppColors.lavender,
                style: const TextStyle(
                  color: AppColors.dark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                items: [
                  'ALL',
                  'BREAST',
                  'OVARIAN',
                  'PROSTATE',
                  'MELANOMA',
                  'COLORECTAL',
                ]
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyle(
                              color: _category == type
                                  ? Colors.deepPurple
                                  : AppColors.dark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
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
                title: isEdit ? "Update News" : 'Add News',
                onClick: _submitNews,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
