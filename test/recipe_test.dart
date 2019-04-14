import 'dart:io';

import 'package:cka/recipe.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html/parser.dart';

void main() {
  test('parse ck results page', () async {
    File file = File('testhtml/bohnen.html');
    file.readAsString().then((String contents) {
      var body = parse(contents);
      var ckdocsel = CKDocSelection(body.querySelector('.search-list-item'));
      expect(ckdocsel.title(), 'Grüne Bohnen im Speckmantel');
      expect(ckdocsel.subtitle(),
          "Bohnen waschen und die Spitzen abschneiden. Bohnenkraut, Knoblauch, zerdrückte Pfefferkörner und Salz mit Öl kurz anrösten. 2 Lite...");
      expect(ckdocsel.url(), 'https://www.chefkoch.de/rezepte/563451154612271/Gruene-Bohnen-im-Speckmantel.html');
      expect(ckdocsel.thumbnail(),'https://static.chefkoch-cdn.de/rs/bilder/56345/gruene-bohnen-im-speckmantel-1124631-150x150.jpg' );
      expect(ckdocsel.rating(), '4.49');
    });
  });
}
