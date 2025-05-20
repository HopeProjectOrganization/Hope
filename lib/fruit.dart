import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FruitListScreen extends StatefulWidget {
  static const routeName = '/fruit';

  const FruitListScreen({super.key});

  @override
  State<FruitListScreen> createState() => _FruitListScreenState();
}

class _FruitListScreenState extends State<FruitListScreen> {
  late Future<List<dynamic>> fruits;

  @override
  void initState() {
    super.initState();
    fruits = fetchFruits();
  }

  Future<List<dynamic>> fetchFruits() async {
    final url = Uri.parse('https://www.fruityvice.com/api/fruit/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load fruits');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fruits Info')),
      body: FutureBuilder<List<dynamic>>(
        future: fruits,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found.'));
          }

          final fruitList = snapshot.data!;
          return ListView.separated(
            itemCount: fruitList.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final fruit = fruitList[index];
              final nutrition = fruit['nutritions'] ?? {};

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(fruit['name'] ?? 'No Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Family: ${fruit['family'] ?? 'N/A'}"),
                      Text("Genus: ${fruit['genus'] ?? 'N/A'}"),
                      Text("Order: ${fruit['order'] ?? 'N/A'}"),
                      Text("Calories: ${nutrition['calories'] ?? 'N/A'}"),
                      Text("Sugar: ${nutrition['sugar'] ?? 'N/A'}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
