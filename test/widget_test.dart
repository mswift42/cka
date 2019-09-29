// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cka/main.dart';
import 'package:cka/screens/fvaourites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('test correct title in app', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(CKApp());
    final titleFinder = find.text('CK');
    expect(titleFinder, findsOneWidget);
  });

  testWidgets('search filters have a label', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: RecipeSearch(),
    ));
    final searchFilterFinder = find.text('relevanz');
    final searchFilterFinder2 = find.text('bewertung');
    expect(searchFilterFinder, findsOneWidget);
    expect(searchFilterFinder2, findsOneWidget);
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);
  });

  testWidgets('FavouriteWidgets have a delete icon',
      (WidgetTester tester) async {
    await tester.pumpWidget(FavouritesView());
  });
}
