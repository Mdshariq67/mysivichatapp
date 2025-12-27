import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mysivichatapp/main.dart';

void main() {
  testWidgets('Add user and navigate to chat screen', (tester) async {
    await tester.pumpWidget(MyApp());

    // Home screen loaded
    expect(find.text('Users'), findsOneWidget);

    // Tap FAB to add user
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Enter name
    await tester.enterText(find.byType(TextField), 'Alice');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // User should appear
    expect(find.text('Alice'), findsOneWidget);

    // Tap user
    await tester.tap(find.text('Alice'));
    await tester.pumpAndSettle();

    // Chat screen opens
    expect(find.byIcon(Icons.send), findsOneWidget);
  });
}
