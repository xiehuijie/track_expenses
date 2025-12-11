import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../screens/home_screen.dart';
import 'theme_provider.dart';

class MaterialShowcaseApp extends StatefulWidget {
  const MaterialShowcaseApp({super.key});

  @override
  State<MaterialShowcaseApp> createState() => _MaterialShowcaseAppState();
}

class _MaterialShowcaseAppState extends State<MaterialShowcaseApp> {
  ThemeMode _themeMode = ThemeMode.system;
  AppThemeColor _themeColor = AppThemeColor.deepPurple;
  Locale _locale = const Locale('zh', 'CN');

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  void _changeThemeColor(AppThemeColor color) {
    setState(() {
      _themeColor = color;
    });
  }

  void _changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material Design Showcase',
      debugShowCheckedModeBanner: false,
      theme: AppThemeProvider.getTheme(_themeColor, Brightness.light),
      darkTheme: AppThemeProvider.getTheme(_themeColor, Brightness.dark),
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('zh', 'CN'), Locale('en', 'US')],
      home: HomeScreen(
        onToggleTheme: _toggleTheme,
        onChangeThemeColor: _changeThemeColor,
        onChangeLocale: _changeLocale,
        currentThemeColor: _themeColor,
        currentLocale: _locale,
      ),
    );
  }
}
