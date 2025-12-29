import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:precious_metals_app/features/home/home_page.dart';

void main() {
  testWidgets('Home page renders correctly', (WidgetTester tester) async {
    // Build the home page wrapped in ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    // Verify that the home page renders
    expect(find.text('Precious Metals'), findsOneWidget);
    expect(find.text('Home Page - Coming Soon'), findsOneWidget);
  });
}
