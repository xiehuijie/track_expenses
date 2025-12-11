// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:track_expenses/app/app.dart';

void main() {
  testWidgets('App launches and shows home screen', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialShowcaseApp());
    await tester.pumpAndSettle();

    // Verify that the app shows the Material Design Showcase title
    expect(find.text('Material Design Showcase'), findsOneWidget);

    // Verify that the bottom navigation bar is visible
    expect(find.byType(NavigationBar), findsOneWidget);

    // Verify that an AppBar is present
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('Navigation bar has multiple destinations', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialShowcaseApp());
    await tester.pumpAndSettle();

    // Verify navigation destinations exist
    expect(find.byType(NavigationDestination), findsWidgets);

    // Check for category names
    expect(find.text('Material 组件'), findsOneWidget);
    expect(find.text('数据存储'), findsOneWidget);
  });

  testWidgets('Theme toggle button exists', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialShowcaseApp());
    await tester.pumpAndSettle();

    // Find a theme toggle button (could be dark_mode or light_mode icon)
    final darkModeButton = find.byIcon(Icons.dark_mode);
    final lightModeButton = find.byIcon(Icons.light_mode);

    // One of them should be present
    expect(
      darkModeButton.evaluate().isNotEmpty ||
          lightModeButton.evaluate().isNotEmpty,
      isTrue,
    );
  });

  testWidgets('Scaffold structure is correct', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialShowcaseApp());
    await tester.pumpAndSettle();

    // Verify basic scaffold structure
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
