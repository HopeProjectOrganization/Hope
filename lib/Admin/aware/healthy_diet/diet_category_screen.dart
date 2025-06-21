// file: diet_category_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hope/Admin/aware/healthy_diet/addHealthyScreen.dart';
import 'package:hope/core/theme/app_colors.dart';
import 'package:hope/main.dart';
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
  String searchQuery = "";
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    category = ModalRoute.of(context)!.settings.arguments as String;
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse('http://${MyApp.IP}/api/diet/category/$category');
    print("Selected category: $category");

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
    final filteredItems = items.where((item) {
      final title = item['title']?.toLowerCase() ?? '';
      final description = item['description']?.toLowerCase() ?? '';
      return title.contains(searchQuery) || description.contains(searchQuery);
    }).toList();
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(
              context,
              AdminHealthyEditorScreen.routeName,
              arguments: {"category": category},
            );
            if (result == true) {
              fetchData(); // reload list after adding
            }
          },
          backgroundColor: AppColors.Teal,
          child: const Icon(
            Icons.add,
            color: AppColors.lavender,
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                SafeArea(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: const BoxDecoration(
                      color: AppColors.Teal,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // رجوع للخلف
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child:
                              const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        // شريط البحث
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value.toLowerCase();
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            // <== دي لازم
                            fillColor: AppColors.white,
                            // <== ودي تحدد اللون
                            hintText: 'Search here',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon:
                                Icon(Icons.search, color: AppColors.Teal),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // نص العنوان
                        const Text(
                          'Discover recipes',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(height: 26),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredItems.isEmpty
                          ? const Center(child: Text('No data found.'))
                          : ListView.builder(
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Row(
                                      children: [
                                        // Left side
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.star_border,
                                                    size: 20,
                                                    color: Colors.black54),
                                                const SizedBox(height: 8),
                                                Text(
                                                  item['title'] ??
                                                      'Green Salad',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${item['description']}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.dark,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Right side: half circular image
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(100),
                                            bottomLeft: Radius.circular(100),
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            widthFactor: 0.5,
                                            child: Image.network(
                                              item['imageUrl'] ??
                                                  'https://example.com/your-image.jpg',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.15,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                    Icons.broken_image,
                                                    size: 40),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
