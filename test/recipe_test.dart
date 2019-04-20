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
    expect(sel1.thumbnail(),
        'https://static.chefkoch-cdn.de/rs/bilder/316621/gruene-bohnen-938192-150x150.jpg');
    expect(sel1.url(),
        'https://www.chefkoch.de/rezepte/3166211471333987/Gruene-Bohnen.html');
    expect(sel1.rating(), '4.36');
    expect(sel1.difficulty(), 'simpel');
    expect(sel1.preptime(), '10 min.');
    var sel2 = CKDocSelection(selections[2]);
    expect(sel2.title(), 'Schupfnudel - Bohnen - Pfanne');
    expect(sel2.url(),
        'https://www.chefkoch.de/rezepte/1171381223217983/Schupfnudel-Bohnen-Pfanne.html');
    expect(sel2.thumbnail(),
        'https://static.chefkoch-cdn.de/rs/bilder/117138/schupfnudel-bohnen-pfanne-1156413-150x150.jpg');
    expect(sel2.rating(), '4.37');
    expect(sel2.difficulty(), 'normal');
    expect(sel2.preptime(), '30 min.');
    var sel3 = CKDocSelection(selections[3]);
    expect(sel3.title(), 'Grüne Bohnen mit Speck');
    expect(sel3.url(),
        'https://www.chefkoch.de/rezepte/2406611380140966/Gruene-Bohnen-mit-Speck.html');
    expect(sel3.thumbnail(),
        'https://static.chefkoch-cdn.de/rs/bilder/240661/gruene-bohnen-mit-speck-1135575-150x150.jpg');
    expect(sel3.rating(), '4.67');
    expect(sel3.difficulty(), 'normal');
    expect(sel3.preptime(), '25 min.');
  });

  test('parse results page with sahne html file', () {
    File file = File('test/testhtml/sahne.html');
    var contents = file.readAsStringSync();
    var body = parse(contents);
    var selections = body.querySelectorAll('.search-list-item');
    var sel1 = CKDocSelection(selections[0]);
    expect(sel1.title(), 'Pasta mit Sahne - Rahm - Zitronen - Sauce');
    expect(sel1.url(),
        'https://www.chefkoch.de/rezepte/541291151424031/Pasta-mit-Sahne-Rahm-Zitronen-Sauce.html');
    expect(sel1.thumbnail(),
        'https://static.chefkoch-cdn.de/rs/bilder/54129/pasta-mit-sahne-rahm-zitronen-sauce-976379-150x150.jpg');
    expect(sel1.rating(), '3.59');
    expect(sel1.difficulty(), 'normal');
    expect(sel1.preptime(), '25 min.');
    var sel2 = CKDocSelection(selections[1]);
    expect(
        sel2.title(), 'Maulwurfkuchen mit Quark, saurer Sahne und Schlagsahne');
    expect(sel2.url(),
        'https://www.chefkoch.de/rezepte/2022801328087014/Maulwurfkuchen-mit-Quark-saurer-Sahne-und-Schlagsahne.html');
    expect(sel2.thumbnail(),
        'https://static.chefkoch-cdn.de/rs/bilder/202280/maulwurfkuchen-mit-quark-saurer-sahne-und-schlagsahne-1071992-150x150.jpg');
    expect(sel2.rating(), '3.6');
    expect(sel2.difficulty(), 'normal');
    expect(sel2.preptime(), '75 min.');
    var sel3 = CKDocSelection(selections[2]);
    expect(sel3.title(),
        'Kleine Kartoffel - Speckknödel mit Pfifferlingen in Rahm');
    expect(sel3.url(),
        'https://www.chefkoch.de/rezepte/1112271217262021/Kleine-Kartoffel-Speckknoedel-mit-Pfifferlingen-in-Rahm.html');
    expect(sel3.thumbnail(),
        'https://static.chefkoch-cdn.de/rs/bilder/111227/kleine-kartoffel-speckknoedel-mit-pfifferlingen-in-rahm-117087-150x150.jpg');
    expect(sel3.rating(), '4.23');
    expect(sel3.difficulty(), 'normal');
    expect(sel3.preptime(), '45 min.');
    var sel4 = CKDocSelection(selections[3]);
    expect(sel4.title(), 'Käse-Sahne-Dessert');
    expect(sel4.url(),
        'https://www.chefkoch.de/rezepte/914011196708021/Kaese-Sahne-Dessert.html');
    expect(sel4.thumbnail(),
        'https://static.chefkoch-cdn.de/rs/bilder/91401/kaese-sahne-dessert-1002666-150x150.jpg');
    expect(sel4.rating(), '4.6');
    expect(sel4.difficulty(), 'simpel');
    expect(sel4.preptime(), '25 min.');
    var sel5 = CKDocSelection(selections[10]);
    expect(sel5.title(), 'Gebackene Quitten mit Schlagsahne');
    expect(sel5.url(),
        'https://www.chefkoch.de/rezepte/572911155974191/Gebackene-Quitten-mit-Schlagsahne.html');
    expect(sel5.thumbnail(),
        'https://static.chefkoch-cdn.de/rs/bilder/57291/gebackene-quitten-mit-schlagsahne-1151615-150x150.jpg');
    expect(sel5.rating(), '4.29');
    expect(sel5.difficulty(), 'simpel');
    expect(sel5.preptime(), '20 min.');
    var sel6 = CKDocSelection(selections[11]);
    expect(sel6.title(), 'Wodka - Sahne - Likör');
    expect(sel6.url(),
        'https://www.chefkoch.de/rezepte/381531124489612/Wodka-Sahne-Likoer.html');
    expect(sel6.thumbnail(),
        'https://static.chefkoch-cdn.de/rs/bilder/38153/wodka-sahne-likoer-968928-150x150.jpg');
    expect(sel6.rating(), '4.54');
    expect(sel6.difficulty(), 'simpel');
    expect(sel6.preptime(), '15 min.');
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

    file = File('test/testhtml/schupfnudel.html');
    contents = file.readAsStringSync();
    body = parse(contents);
    rd = RecipeDetail.fromDoc(RecipeDetailDocument(body));
    expect(rd.title, 'Schupfnudel - Bohnen - Pfanne');
    expect(rd.difficulty, 'normal');
    expect(rd.thumbnail,
        'https://static.chefkoch-cdn.de/ck.de/rezepte/117/117138/1156413-420x280-fix-schupfnudel-bohnen-pfanne.jpg');
    expect(rd.preptime, 'ca. 30 Min.');
    expect(rd.cookingtime, '');
    expect(rd.rating, '4.37');
    expect(rd.ingredients.length, 8);
  });
}
