import 'package:flutter/material.dart';
import 'package:frontend/config/dependencies.dart';
import 'package:frontend/ui/core/themes/theme.dart';
import 'package:frontend/ui/generate/generate_page.dart';

void main() {
  setupInjection();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: dartTheme,
      home: const GeneratePage(),
    );
  }
}
