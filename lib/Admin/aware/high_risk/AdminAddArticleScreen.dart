import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hope/main.dart';
import 'package:hope/ui/shared_widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminAddArticleScreen extends StatefulWidget {
  static const String routeName = '/adminAddArticle';

  @override
  State<AdminAddArticleScreen> createState() => _AdminAddArticleScreenState();
}

class _AdminAddArticleScreenState extends State<AdminAddArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _article = <String, dynamic>{};
  File? _pickedImage;

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

    if (_pickedImage != null) {
      final imageUrl = await _uploadImage(_pickedImage!);
      _article['imageUrl'] = imageUrl;
    }

    final response = await http.post(
      Uri.parse('https://${MyApp.IP}/api/highrisk'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(_article),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article added successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add article: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Article")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Article ID'),
                onSaved: (val) => _article['articleId'] = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (val) => _article['title'] = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Link'),
                onSaved: (val) => _article['link'] = val,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Keywords (comma separated)'),
                onSaved: (val) => _article['keywords'] =
                    val?.split(',').map((e) => e.trim()).toList(),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Creator (comma separated)'),
                onSaved: (val) => _article['creator'] =
                    val?.split(',').map((e) => e.trim()).toList(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (val) => _article['description'] = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Content'),
                onSaved: (val) => _article['content'] = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Published Date'),
                onSaved: (val) => _article['pubDate'] = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Video URL'),
                onSaved: (val) => _article['videoUrl'] = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Source ID'),
                onSaved: (val) => _article['sourceId'] = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Source Name'),
                onSaved: (val) => _article['sourceName'] = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Source Priority'),
                keyboardType: TextInputType.number,
                onSaved: (val) =>
                    _article['sourcePriority'] = int.tryParse(val ?? '0'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Source URL'),
                onSaved: (val) => _article['sourceUrl'] = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Source Icon'),
                onSaved: (val) => _article['sourceIcon'] = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Language'),
                onSaved: (val) => _article['language'] = val,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Country (comma separated)'),
                onSaved: (val) => _article['country'] =
                    val?.split(',').map((e) => e.trim()).toList(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                onSaved: (val) => _article['category'] = val,
              ),
              CheckboxListTile(
                title: const Text("Is Duplicate"),
                value: _article['duplicate'] ?? false,
                onChanged: (val) => setState(() => _article['duplicate'] = val),
              ),
              const SizedBox(height: 12),
              if (_pickedImage != null) Image.file(_pickedImage!, height: 150),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Pick Image"),
              ),
              const SizedBox(height: 16),
              CustomButton(title: 'Submit', onClick: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
