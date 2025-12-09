import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import 'theme.dart';

class MaterialShowcaseApp extends StatefulWidget {
  const MaterialShowcaseApp({super.key});

  @override
  State<MaterialShowcaseApp> createState() => _MaterialShowcaseAppState();
}

class _MaterialShowcaseAppState extends State<MaterialShowcaseApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material Design Showcase',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: HomeScreen(onToggleTheme: _toggleTheme),
    );
  }
}
