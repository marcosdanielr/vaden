import 'package:flutter/material.dart';
import 'config/dependencies.dart';
import 'ui/core/themes/theme.dart';
import 'ui/generate/generate_page.dart';

void main() {
  setupInjection();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vaden generator',
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: dartTheme,
      home: const GeneratePage(),
    );
  }
}
