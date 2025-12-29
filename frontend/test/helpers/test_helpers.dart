import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Create a testable widget wrapped with necessary providers
Widget createTestableWidget(Widget child, {List<Override>? overrides}) {
  return ProviderScope(
    overrides: overrides ?? [],
    child: MaterialApp(
      home: child,
    ),
  );
}

/// Create a testable widget with router
Widget createTestableWidgetWithRouter(Widget child, {List<Override>? overrides}) {
  return ProviderScope(
    overrides: overrides ?? [],
    child: MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

/// Pump and settle with a custom duration
Future<void> pumpAndSettleWithDuration(
  WidgetTester tester, {
  Duration duration = const Duration(milliseconds: 100),
}) async {
  await tester.pump(duration);
  await tester.pumpAndSettle();
}
