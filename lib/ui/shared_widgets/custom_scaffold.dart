import 'package:flutter/material.dart';
import 'package:hope/core/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold(
      {super.key, required this.title, this.actions, this.body});

  final String title;
  final List<Widget>? actions;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(title),
        centerTitle: true,
        actions: actions,
      ),
      body: body,
    );
  }
}
