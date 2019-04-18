import 'dart:io';

import 'package:cka/recipe.dart';
import 'package:html/parser.dart';
import 'package:test/test.dart';

void main() {
  test('parse ck results page', () {
    File file = File('test/testhtml/bohnen.html');
    var contents = file.readAsStringSync();
    var body = parse(contents);
    var ckdocsel = CKDocSelection(body.querySelector('.search-list-item'));
    expect(ckdocsel.title(), 'Grüne Bohnen im Speckmantel');
    expect(ckdocsel.subtitle(),
        "Bohnen waschen und die Spitzen abschneiden.Bohnenkraut, Knoblauch, zerdrückte Pfefferkörner und Salz mit Öl kurz anrösten. 2 Lite...");
    expect(ckdocsel.url(),
        'https://www.chefkoch.de/rezepte/563451154612271/Gruene-Bohnen-im-Speckmantel.html');
    expect(ckdocsel.thumbnail(),
        'https://static.chefkoch-cdn.de/rs/bilder/56345/gruene-bohnen-im-speckmantel-1124631-150x150.jpg');
    expect(ckdocsel.rating(), '4.49');
    expect(ckdocsel.difficulty(), 'simpel');
    expect(ckdocsel.preptime(), '30 min.');
    var selections = body.querySelectorAll('.search-list-item');
    var sel1 = CKDocSelection(selections[1]);
    expect(sel1.title(), 'Grüne Bohnen');
    expect(sel1.subtitle(),
        'Variante 1:Die Bohnen putzen. Zwiebeln und Knoblauch klein schneiden und in etwas Butter oder Margarine anbraten. Die Bohnen dazu...');
    expect(sel1.thumbnail(),
        'https://static.chefkoch-cdn.de/rs/bilder/316621/gruene-bohnen-938192-150x150.jpg');
    expect(sel1.url(),
        'https://www.chefkoch.de/rezepte/3166211471333987/Gruene-Bohnen.html');
    expect(sel1.rating(), '4.36');
    expect(sel1.difficulty(), 'simpel');
    expect(sel1.preptime(), '10 min.');
    var sel2 = CKDocSelection(selections[2]);
    expect(sel2.title(), 'Schupfnudel - Bohnen - Pfanne');
    expect(sel2.subtitle(),
        'Pfannengericht mit Bohnen, Schinken, Schupfnudeln und Crème fraiche');
    expect(sel2.url(),
        'https://www.chefkoch.de/rezepte/1171381223217983/Schupfnudel-Bohnen-Pfanne.html');
    expect(sel2.thumbnail(),
        'https://static.chefkoch-cdn.de/rs/bilder/117138/schupfnudel-bohnen-pfanne-1156413-150x150.jpg');
    expect(sel2.rating(), '4.37');
    expect(sel2.difficulty(), 'normal');
    expect(sel2.preptime(), '30 min.');
    var sel3 = CKDocSelection(selections[3]);
    expect(sel3.title(), 'Grüne Bohnen mit Speck');
    expect(sel3.subtitle(), 'Speckbohnen');
    expect(sel3.url(),
        'https://www.chefkoch.de/rezepte/2406611380140966/Gruene-Bohnen-mit-Speck.html');
    expect(sel3.thumbnail(),
        'https://static.chefkoch-cdn.de/rs/bilder/240661/gruene-bohnen-mit-speck-1135575-150x150.jpg');
    expect(sel3.rating(), '4.67');
    expect(sel3.difficulty(), 'normal');
    expect(sel3.preptime(), '25 min.');
  });

  test('parse Recipe detail page', () {
    File file = File('test/testhtml/gruene_bohnen_im_speckmantel.html');
    var contents = file.readAsStringSync();
    var body = parse(contents);
    var rd = RecipeDetail.fromDoc(RecipeDetailDocument(body));
    expect(rd.title, 'Grüne Bohnen im Speckmantel');
    expect(rd.difficulty, 'simpel');
    expect(rd.thumbnail,
        'https://static.chefkoch-cdn.de/ck.de/rezepte/56/56345/1124631-420x280-fix-gruene-bohnen-im-speckmantel.jpg');
    expect(rd.preptime, 'ca. 30 Min.');
    expect(rd.cookingtime, 'ca. 15 Min.');
    expect(rd.ingredients[0].amount, '800\u00a0g');
    expect(rd.ingredients[0].ingredient, 'Bohnen, frische');
    expect(rd.ingredients[1].amount, '1\u00a0Bund');
    expect(rd.ingredients[1].ingredient, 'Bohnenkraut');
    expect(rd.ingredients[7].amount, '1\u00a0EL');
    expect(rd.ingredients[7].ingredient, 'Butter');
  });
}
