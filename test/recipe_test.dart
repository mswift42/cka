import 'dart:io';

import 'package:cka/recipe.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html/parser.dart';

void main() {
  test('parse ck results page', () {
    File file = File('testhtml/bohnen.html');
    file.readAsString().then((String contents) {
      var body = parse(contents);
      var ckdocsel = CKDocSelection(body.querySelector('.search-list-item'));
      expect(ckdocsel.title(), 'Grüne Bohnen im Speckmantel');
    });
  });
}
