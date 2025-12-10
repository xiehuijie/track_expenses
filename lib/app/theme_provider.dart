import 'package:flutter/material.dart';

enum AppThemeColor {
  deepPurple(Colors.deepPurple, '紫色', 'Purple'),
  blue(Colors.blue, '蓝色', 'Blue'),
  red(Colors.red, '红色', 'Red'),
  green(Colors.green, '绿色', 'Green'),
  orange(Colors.orange, '橙色', 'Orange'),
  teal(Colors.teal, '青色', 'Teal'),
  pink(Colors.pink, '粉色', 'Pink'),
  amber(Colors.amber, '琥珀色', 'Amber'),
  indigo(Colors.indigo, '靛蓝色', 'Indigo'),
  cyan(Colors.cyan, '青蓝色', 'Cyan');

  final Color color;
  final String nameCn;
  final String nameEn;

  const AppThemeColor(this.color, this.nameCn, this.nameEn);
}

class AppThemeProvider {
  static ThemeData getTheme(AppThemeColor themeColor, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColor.color,
        brightness: brightness,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static List<AppThemeColor> getAllThemeColors() {
    return AppThemeColor.values;
  }
}
