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
      // drawer: Drawer(
      //   child: Column(
      //     children: [
      //       const DrawerHeader(child: Text('News App')),
      //       ListTile(
      //         title: const Text('Go to Home'),
      //         leading: const Icon(Icons.home),
      //         onTap: () {
      //           //ToDo navigate to category Screen
      //           Navigator.pushNamed(context, RegisterScreen.routeName);
      //         },
      //       ),
      //       ListTile(
      //         title: const Text(''),
      //         leading: Icon(themeProvider.isDarkTheme
      //             ? Icons.dark_mode_outlined
      //             : Icons.light_mode_outlined),
      //         onTap: () {
      //           themeProvider.setThemeModeProvider(
      //               themeProvider.isDarkTheme
      //               ? ThemeMode.light
      //               : ThemeMode.dark);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
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
