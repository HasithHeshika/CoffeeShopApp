// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:restaurant_order_system/main.dart';

void main() {
  testWidgets('Coffee Shop app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RestaurantOrderApp());

    // Verify that the app title shows
    expect(find.text('Coffee Shop'), findsOneWidget);

    // Verify that the menu section exists
    expect(find.text('Menu'), findsOneWidget);
  });
}
