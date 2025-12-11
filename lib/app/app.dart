import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/generated/app_localizations.dart';
import '../screens/home_screen.dart';
import 'theme.dart';

class MaterialShowcaseApp extends StatefulWidget {
  const MaterialShowcaseApp({super.key});

  @override
  State<MaterialShowcaseApp> createState() => _MaterialShowcaseAppState();
}

class _MaterialShowcaseAppState extends State<MaterialShowcaseApp> {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeColor _themeColor = ThemeColor.purple;
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final themeModeIndex = prefs.getInt('themeMode') ?? 0;
      _themeMode = ThemeMode.values[themeModeIndex];
      final themeColorIndex = prefs.getInt('themeColor') ?? 0;
      _themeColor = ThemeColor.values[themeColorIndex];
      final localeCode = prefs.getString('locale');
      if (localeCode != null) {
        _locale = Locale(localeCode);
      }
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', _themeMode.index);
    await prefs.setInt('themeColor', _themeColor.index);
    if (_locale != null) {
      await prefs.setString('locale', _locale!.languageCode);
    } else {
      await prefs.remove('locale');
    }
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    _saveSettings();
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
    _saveSettings();
  }

  void _setThemeColor(ThemeColor color) {
    setState(() {
      _themeColor = color;
    });
    _saveSettings();
  }

  void _setLocale(Locale? locale) {
    setState(() {
      _locale = locale;
    });
    _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material Design Showcase',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(_themeColor),
      darkTheme: AppTheme.darkTheme(_themeColor),
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeScreen(
        onToggleTheme: _toggleTheme,
        onSetThemeMode: _setThemeMode,
        onSetThemeColor: _setThemeColor,
        onSetLocale: _setLocale,
        currentThemeMode: _themeMode,
        currentThemeColor: _themeColor,
        currentLocale: _locale,
      ),
    );
  }
}
