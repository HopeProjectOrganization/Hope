import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hope/main.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class AdminHighEditorScreen extends StatefulWidget {
  static const String routeName = '/adminHighRiskEditor';

  final Map<String, dynamic>? newsData;

  const AdminHighEditorScreen({Key? key, this.newsData}) : super(key: key);

  @override
  State<AdminHighEditorScreen> createState() => _AdminHighEditorScreenState();
}

class _AdminHighEditorScreenState extends State<AdminHighEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _descriptionController;
  late TextEditingController _linkController;
  late TextEditingController _videoUrlController;
  late TextEditingController _sourceIdController;
  late TextEditingController _sourceNameController;
  late TextEditingController _sourcePriorityController;
  late TextEditingController _sourceUrlController;
  late TextEditingController _sourceIconController;
  late TextEditingController _languageController;
  late TextEditingController _countryController;
  late TextEditingController _keywordsController;
  late TextEditingController _creatorController;

  String _category = 'ELDERLY';
  bool _duplicate = false;
  File? _pickedImage;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _descriptionController = TextEditingController();
    _linkController = TextEditingController();
    _videoUrlController = TextEditingController();
    _sourceIdController = TextEditingController();
    _sourceNameController = TextEditingController();
    _sourcePriorityController = TextEditingController();
    _sourceUrlController = TextEditingController();
    _sourceIconController = TextEditingController();
    _languageController = TextEditingController();
    _countryController = TextEditingController();
    _keywordsController = TextEditingController();
    _creatorController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _titleController.text = args['title'] ?? '';
        _contentController.text = args['content'] ?? '';
        _descriptionController.text = args['description'] ?? '';
        _linkController.text = args['link'] ?? '';
        _videoUrlController.text = args['videoUrl'] ?? '';
        _sourceIdController.text = args['sourceId'] ?? '';
        _sourceNameController.text = args['sourceName'] ?? '';
        _sourcePriorityController.text =
            args['sourcePriority']?.toString() ?? '0';
        _sourceUrlController.text = args['sourceUrl'] ?? '';
        _sourceIconController.text = args['sourceIcon'] ?? '';
        _languageController.text = args['language'] ?? 'en';
        _countryController.text = args['country']?.join(',') ?? '';
        _keywordsController.text = args['keywords']?.join(',') ?? '';
        _creatorController.text = args['creator']?.join(',') ?? '';
        _category = args['category'] ?? 'ELDERLY';
        _duplicate = args['duplicate'] ?? false;
        _existingImageUrl = args['imageUrl'];
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
          FirebaseStorage.instance.ref().child('highrisk_images/$fileName.jpg');
      final uploadTask = await ref.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  void _submitNews() async {
    if (!_formKey.currentState!.validate()) return;

    String imageUrl = _existingImageUrl ?? '';
    if (_pickedImage != null) {
      final uploadedUrl = await _uploadImageToFirebase(_pickedImage!);
      if (uploadedUrl != null) imageUrl = uploadedUrl;
    }

    final news = {
      "title": _titleController.text,
      "content": _contentController.text,
      "description": _descriptionController.text,
      "link": _linkController.text,
      "videoUrl": _videoUrlController.text,
      "sourceId": _sourceIdController.text,
      "sourceName": _sourceNameController.text,
      "sourcePriority": int.tryParse(_sourcePriorityController.text) ?? 0,
      "sourceUrl": _sourceUrlController.text,
      "sourceIcon": _sourceIconController.text,
      "language": _languageController.text,
      "country":
          _countryController.text.split(',').map((e) => e.trim()).toList(),
      "keywords":
          _keywordsController.text.split(',').map((e) => e.trim()).toList(),
      "creator":
          _creatorController.text.split(',').map((e) => e.trim()).toList(),
      "category": _category,
      "duplicate": _duplicate,
      "imageUrl": imageUrl,
    };

    final isEdit = widget.newsData != null && widget.newsData!['id'] != null;
    final id = widget.newsData?['id'];
    final url = isEdit
        ? 'http://${MyApp.IP}/api/highrisk/$id'
        : 'http://${MyApp.IP}/api/highrisk';

    final response = await (isEdit
        ? Uri.parse(url).sendJsonPut(news)
        : Uri.parse(url).sendJsonPost(news));

    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isEdit ? 'News updated' : 'News added'),
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('High Risk Editor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _category,
                onChanged: (val) => setState(() => _category = val!),
                items: [
                  'ELDERLY',
                  'PREGNANT',
                  'WEAK_IMMUNE_SYSTEM',
                  'SMOKERS',
                  'OBESE',
                  'GENETIC_MUTATION',
                  'INACTIVE',
                  'CHEMICAL_EXPOSURE',
                  'POLLUTED_AREAS',
                ]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 10),
              _buildTextField(_titleController, 'Title'),
              _buildTextField(_descriptionController, 'Description'),
              _buildTextField(_linkController, 'Link'),
              _buildTextField(_contentController, 'Content', maxLines: 3),
              _buildTextField(_videoUrlController, 'Video URL'),
              _buildTextField(_sourceIdController, 'Source ID'),
              _buildTextField(_sourceNameController, 'Source Name'),
              _buildTextField(_sourcePriorityController, 'Source Priority'),
              _buildTextField(_sourceUrlController, 'Source URL'),
              _buildTextField(_sourceIconController, 'Source Icon'),
              _buildTextField(_languageController, 'Language'),
              _buildTextField(_countryController, 'Country (comma separated)'),
              _buildTextField(
                  _keywordsController, 'Keywords (comma separated)'),
              _buildTextField(_creatorController, 'Creator (comma separated)'),
              SwitchListTile(
                title: const Text('Duplicate'),
                value: _duplicate,
                onChanged: (val) => setState(() => _duplicate = val),
              ),
              const SizedBox(height: 10),
              _pickedImage != null
                  ? Image.file(_pickedImage!, height: 150)
                  : (_existingImageUrl != null)
                      ? Image.network(_existingImageUrl!, height: 150)
                      : GestureDetector(
                          onTap: _pickImage,
                          child: SizedBox(
                            height: 150,
                            child:
                                Lottie.asset('assets/lottie/imagePicker.json'),
                          ),
                        ),
              const SizedBox(height: 20),
              CustomButton(title: 'Submit', onClick: _submitNews),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration:
            InputDecoration(labelText: label, border: OutlineInputBorder()),
        maxLines: maxLines,
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      ),
    );
  }
}

extension on Uri {
  Future<bool> sendJsonPost(Map<String, dynamic> data) async {
    final response = await HttpClient().postUrl(this).then((req) async {
      req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      req.add(utf8.encode(jsonEncode(data)));
      return await req.close();
    });
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> sendJsonPut(Map<String, dynamic> data) async {
    final response = await HttpClient().putUrl(this).then((req) async {
      req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      req.add(utf8.encode(jsonEncode(data)));
      return await req.close();
    });
    return response.statusCode == 200;
  }
}
