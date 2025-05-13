// file: diet_category_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/Admin/aware/healthy_diet/addHealthyScreen.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:http/http.dart' as http;

class DietCategoryScreen extends StatefulWidget {
  static const routeName = '/dietCategoryScreen';

  const DietCategoryScreen({super.key});

  @override
  State<DietCategoryScreen> createState() => _DietCategoryScreenState();
}

class _DietCategoryScreenState extends State<DietCategoryScreen> {
  late String category;
  List<dynamic> items = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    category = ModalRoute.of(context)!.settings.arguments as String;
    fetchData();
  }

  Future<void> fetchData() async {
    final url =
        Uri.parse('http://192.168.78.153:8080/api/diet/category=$category');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          items = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? const Center(child: Text('No data found.'))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(item['title'] ?? ''),
                        subtitle: Text(item['description'] ?? ''),
                        leading: Image.network(
                          item['imageUrl'] ?? '',
                          width: 60,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                        ),
                        trailing: Text(item['date'] ?? ''),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            AdminHealthyEditorScreen.routeName,
            arguments: {"category": category},
          );

          if (result == true) {
            fetchData(); // Reload after adding new item
          }
        },
        backgroundColor: AppColors.purple,
        child: const Icon(
          Icons.add,
          color: AppColors.lavender,
        ),
      ),
    );
  }
}
