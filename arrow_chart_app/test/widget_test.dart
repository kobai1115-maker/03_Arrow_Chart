import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arrow_chart_app/screens/diagram_editor_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        home: DiagramEditorScreen(),
      ),
    ));

    // Verify that the editor screen is displayed.
    expect(find.byType(DiagramEditorScreen), findsOneWidget);
  });
}
