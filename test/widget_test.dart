// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:iven_track/app.dart';

void main() {
  testWidgets('Login screen appears', (WidgetTester tester) async {
    await tester.pumpWidget(const InvenTrackApp());

    expect(find.text('InvenTrack'), findsOneWidget);
    expect(find.text('Sign In to Dashboard'), findsOneWidget);
  });

  testWidgets('Requests filter icon button works', (WidgetTester tester) async {
    await tester.pumpWidget(const InvenTrackApp());

    await tester.tap(find.text('Sign In to Dashboard'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Requests'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Filter requests'));
    await tester.pump();

    expect(find.text('Filter request dibuka'), findsOneWidget);
  });
}
