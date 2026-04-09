import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:udm/main.dart';

void main() {
  testWidgets('App loads without registration', (WidgetTester tester) async {
    await tester.pumpWidget(const UdmurtKylApp());

    // Verify that the app renders
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
