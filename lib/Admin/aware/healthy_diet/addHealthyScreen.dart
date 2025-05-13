import 'package:flutter/material.dart';

class AdminHealthyEditorScreen extends StatefulWidget {
  Map<String, dynamic>? newsData;

  static const String routeName = '/adminNewsEditor';

  AdminHealthyEditorScreen({Key? key, this.newsData}) : super(key: key);

  @override
  State<AdminHealthyEditorScreen> createState() =>
      _AdminNewsEditorScreenState();
}

class _AdminNewsEditorScreenState extends State<AdminHealthyEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _category;

  final List<String> categories = [
    "RECOMMENDED_FOODS",
    "RECIPES",
    "HELPFUL_FOODS",
    "BAD_FOODS",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.newsData != null) {
      _titleController.text = widget.newsData!['title'] ?? '';
      _descriptionController.text = widget.newsData!['description'] ?? '';
      _category = widget.newsData!['category'];
    }

    // Safety check: ensure _category is valid
    if (!categories.contains(_category)) {
      _category = null;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveNews() {
    if (_formKey.currentState!.validate()) {
      final newsItem = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'category': _category,
      };

      // يمكنك هنا إرسال البيانات إلى الخادم أو قاعدة البيانات
      print("News Saved: $newsItem");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('News item saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.newsData == null ? 'Add News' : 'Edit News'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title Field
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

              // Description Field
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

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: categories.contains(_category) ? _category : null,
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _category = newValue;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select a category'
                    : null,
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _saveNews,
                child:
                    Text(widget.newsData == null ? 'Add News' : 'Update News'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
