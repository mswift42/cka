import 'dart:io';

import 'package:cka/recipe.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:test/test.dart';

Document _body(String filename) {
  File file = File(filename);
  var contents = file.readAsStringSync();
  return parse(contents);
}

void main() {
  test('parse ck results page', () {
    Document body = _body('test/testhtml/bohnen.html');
    var ckdocsel = CKDocSelection(body.querySelector('.rsel-item'));
    expect(ckdocsel.title(), 'Bohnen mit Bohnen - Wok');
    expect(ckdocsel.url(),
        'https://www.chefkoch.de/rezepte/427941133819290/Bohnen-mit-Bohnen-Wok.html');
    expect(ckdocsel.thumbnail(),
        'https://img.chefkoch-cdn.de/images/crop-414x414/amp/assets/images/recipe_fallback_image.jpg');
    expect(ckdocsel.difficulty(), 'simpel');
    expect(ckdocsel.preptime(), '20 min.');
    var selections = body.querySelectorAll('.rsel-item');
    var sel1 = CKDocSelection(selections[1]);
    expect(sel1.title(), 'Grüne Bohnen im Speckmantel');
    expect(sel1.thumbnail(),
        'https://img.chefkoch-cdn.de/rezepte/563451154612271/bilder/1124631/crop-414x414/gruene-bohnen-im-speckmantel.jpg');
    expect(sel1.url(),
        'https://www.chefkoch.de/rezepte/563451154612271/Gruene-Bohnen-im-Speckmantel.html');
    expect(sel1.difficulty(), 'simpel');
    expect(sel1.preptime(), '30 min.');
    var sel2 = CKDocSelection(selections[2]);
    expect(sel2.title(),
        'Mit Ziegenkäse überbackenes Entrecôte an Pfeffersauce, grünen Bohnen und Kartoffelecken');
    expect(sel2.url(),
        'https://www.chefkoch.de/rezepte/836401188402726/Mit-Ziegenkaese-ueberbackenes-Entrec-te-an-Pfeffersauce-gruenen-Bohnen-und-Kartoffelecken.html');
    expect(sel2.thumbnail(),
        'https://img.chefkoch-cdn.de/rezepte/836401188402726/bilder/1052195/crop-414x414/mit-ziegenkaese-ueberbackenes-entrec-te-an-pfeffersauce-gruenen-bohnen-und-kartoffelecken.jpg');
    expect(sel2.difficulty(), 'pfiffig');
    expect(sel2.preptime(), '40 min.');
    var sel4 = CKDocSelection(selections[13]);
    expect(sel4.title(), 'Hähnchenbrust in Schmand mit grünen Bohnen');
    expect(sel4.url(),
        'https://www.chefkoch.de/rezepte/1752251284713110/Haehnchenbrust-in-Schmand-mit-gruenen-Bohnen.html');
    expect(sel4.thumbnail(),
        'https://img.chefkoch-cdn.de/rezepte/1752251284713110/bilder/867585/crop-414x414/haehnchenbrust-in-schmand-mit-gruenen-bohnen.jpg');
    expect(sel4.difficulty(), 'simpel');
    expect(sel4.preptime(), '15 min.');
  });

  test('parse results page with sahne html file', () {
    var body = _body('test/testhtml/sahne.html');
    var selections = body.querySelectorAll('.rsel-item');
    var sel1 = CKDocSelection(selections[0]);
    expect(sel1.title(), 'Pasta mit Sahne - Rahm - Zitronen - Sauce');
    expect(sel1.url(),
        'https://www.chefkoch.de/rezepte/541291151424031/Pasta-mit-Sahne-Rahm-Zitronen-Sauce.html');
    expect(sel1.thumbnail(),
        'https://img.chefkoch-cdn.de/rezepte/541291151424031/bilder/976379/crop-414x414/pasta-mit-sahne-rahm-zitronen-sauce.jpg');
    expect(sel1.difficulty(), 'normal');
    expect(sel1.preptime(), '25 min.');
    var sel2 = CKDocSelection(selections[1]);
    expect(
        sel2.title(), 'Maulwurfkuchen mit Quark, saurer Sahne und Schlagsahne');
    expect(sel2.url(),
        'https://www.chefkoch.de/rezepte/2022801328087014/Maulwurfkuchen-mit-Quark-saurer-Sahne-und-Schlagsahne.html');
    expect(sel2.thumbnail(),
        'https://img.chefkoch-cdn.de/rezepte/2022801328087014/bilder/1071992/crop-414x414/maulwurfkuchen-mit-quark-saurer-sahne-und-schlagsahne.jpg');
    expect(sel2.difficulty(), 'normal');
    expect(sel2.preptime(), '75 min.');
    var sel3 = CKDocSelection(selections[2]);
    expect(sel3.title(), 'Käse-Sahne-Dessert');
    expect(sel3.url(),
        'https://www.chefkoch.de/rezepte/914011196708021/Kaese-Sahne-Dessert.html');
    expect(sel3.thumbnail(),
        'https://img.chefkoch-cdn.de/rezepte/914011196708021/bilder/1002666/crop-414x414/kaese-sahne-dessert.jpg');
    expect(sel3.difficulty(), 'simpel');
    expect(sel3.preptime(), '25 min.');
    var sel4 = CKDocSelection(selections[5]);
    expect(sel4.title(),
        'Kleine Kartoffel - Speckknödel mit Pfifferlingen in Rahm');
    expect(sel4.url(),
        'https://www.chefkoch.de/rezepte/1112271217262021/Kleine-Kartoffel-Speckknoedel-mit-Pfifferlingen-in-Rahm.html');
    expect(sel4.thumbnail(),
        'https://img.chefkoch-cdn.de/rezepte/1112271217262021/bilder/1052252/crop-414x414/kleine-kartoffel-speckknoedel-mit-pfifferlingen-in-rahm.jpg');
    expect(sel4.difficulty(), 'normal');
    expect(sel4.preptime(), '45 min.');
    var sel5 = CKDocSelection(selections[10]);
    expect(sel5.title(), 'Gebackene Quitten mit Schlagsahne');
    expect(sel5.url(),
        'https://www.chefkoch.de/rezepte/572911155974191/Gebackene-Quitten-mit-Schlagsahne.html');
    expect(sel5.thumbnail(),
        'https://img.chefkoch-cdn.de/rezepte/572911155974191/bilder/1151615/crop-414x414/gebackene-quitten-mit-schlagsahne.jpg');
    expect(sel5.difficulty(), 'simpel');
    expect(sel5.preptime(), '20 min.');
    var sel6 = CKDocSelection(selections[11]);
    expect(sel6.title(), 'Wodka - Sahne - Likör');
    expect(sel6.url(),
        'https://www.chefkoch.de/rezepte/381531124489612/Wodka-Sahne-Likoer.html');
    expect(sel6.thumbnail(),
        'https://img.chefkoch-cdn.de/rezepte/381531124489612/bilder/968928/crop-414x414/wodka-sahne-likoer.jpg');
    expect(sel6.difficulty(), 'simpel');
    expect(sel6.preptime(), '15 min.');
  });

  test('parse Recipe detail page', () {
    var body = _body('test/testhtml/gruene_bohnen_im_speckmantel.html');
    var rd = RecipeDetail.fromDoc(RecipeDetailDocument(body));
    expect(rd.title, 'Grüne Bohnen im Speckmantel');
    expect(rd.difficulty, 'simpel');
    expect(rd.thumbnail,
        'https://img.chefkoch-cdn.de/rezepte/563451154612271/bilder/1124631/crop-600x400/gruene-bohnen-im-speckmantel.jpg');
    expect(rd.cookingtime, '30 Min.');
    expect(rd.ingredients[0].amount, '800 g');
    expect(rd.ingredients[0].ingredient, 'Bohnen, frische');
    expect(rd.ingredients[1].amount, '1 Bund');
    expect(rd.ingredients[1].ingredient, 'Bohnenkraut');
    expect(rd.ingredients[7].amount, '1 EL');
    expect(rd.ingredients[7].ingredient, 'Butter');

    body = _body('test/testhtml/schupfnudel.html');
    rd = RecipeDetail.fromDoc(RecipeDetailDocument(body));
    expect(rd.title, 'Schupfnudel - Bohnen - Pfanne');
    expect(rd.difficulty, 'normal');
    expect(rd.thumbnail,
        'https://static.chefkoch-cdn.de/ck.de/rezepte/117/117138/1156413-420x280-fix-schupfnudel-bohnen-pfanne.jpg');
    expect(rd.cookingtime, 'N/A');
    expect(rd.rating, '4.37');
    expect(rd.ingredients.length, 8);
    expect(rd.ingredients[0].amount, '500 g');
    expect(rd.ingredients[0].ingredient, 'Schupfnudeln (Kühlregal)');
    expect(rd.ingredients[1].amount, '200 g');
    expect(rd.ingredients[1].ingredient, 'Schinken, gekochter');
    expect(rd.ingredients[6].amount, 'n. B.');
    expect(rd.ingredients[6].ingredient, 'Salz und Pfeffer');
    expect(rd.ingredients[7].amount, '');
    expect(rd.ingredients[7].ingredient, 'Olivenöl');

    body = _body('test/testhtml/gruene_bohnen_mit_speck.html');
    rd = RecipeDetail.fromDoc(RecipeDetailDocument(body));
    expect(rd.title, 'Grüne Bohnen mit Speck');
    expect(rd.difficulty, 'normal');
    expect(rd.thumbnail,
        'https://static.chefkoch-cdn.de/ck.de/rezepte/240/240661/1135575-420x280-fix-gruene-bohnen-mit-speck.jpg');
    expect(rd.cookingtime, 'ca. 20 Min.');
    expect(rd.rating, '4.67');
    expect(rd.ingredients.length, 7);
    expect(rd.ingredients[0].amount, '500 g');
    expect(rd.ingredients[0].ingredient, 'Bohnen, grüne, frisch oder TK');
    expect(rd.ingredients[1].amount, '1 Pck.');
    expect(rd.ingredients[1].ingredient, 'Speck');
    expect(rd.ingredients[2].amount, '30 g');
    expect(rd.ingredients[2].ingredient, 'Butter');
    expect(rd.ingredients[5].amount, '');
    expect(rd.ingredients[5].ingredient, 'Pfeffer');
    expect(rd.ingredients[6].amount, 'etwas');
    expect(rd.ingredients[6].ingredient, 'Sonnenblumenöl');
  });

  test('test prep info line', () {
    var body = _body('test/testhtml/zimtschnecken.html');
    var rd = RecipeDetail.fromDoc(RecipeDetailDocument(body));
    expect(rd.title, 'Zimtschnecken mit Sahneguss');
    expect(rd.difficulty, 'normal');
    expect(rd.cookingtime, 'ca. 20 Min.');

    body = _body('test/testhtml/hefezopf.html');
    rd = RecipeDetail.fromDoc(RecipeDetailDocument(body));
    expect(rd.title, 'Friedas genialer Hefezopf');
    expect(rd.difficulty, 'normal');
    expect(rd.cookingtime, 'ca. 45 Min.');

    body = _body('test/testhtml/pflaumenkuchen.html');
    rd = RecipeDetail.fromDoc(RecipeDetailDocument(body));
    expect(rd.title, 'Hefe-Pflaumenkuchen');
    expect(rd.difficulty, 'normal');
    expect(rd.cookingtime, 'ca. 30 Min.');

    body = _body('test/testhtml/dampfnudel.html');
    rd = RecipeDetail.fromDoc(RecipeDetailDocument(body));
    expect(rd.title, 'Salzige Dampfnudeln');
    expect(rd.difficulty, 'normal');
    expect(rd.cookingtime, 'ca. 15 Min.');

    body = _body('test/testhtml/brot_im_braeter.html');
    rd = RecipeDetail.fromDoc(RecipeDetailDocument(body));
    expect(rd.title, 'Rustikales Brot im Bräter');
    expect(rd.difficulty, 'simpel');
    expect(rd.cookingtime, 'N/A');

    body = _body('test/testhtml/joghurtbombe.html');
    rd = RecipeDetail.fromDoc(RecipeDetailDocument(body));
    expect(rd.title, 'Joghurtbombe');
    expect(rd.difficulty, 'simpel');
    expect(rd.cookingtime, 'N/A');
  });

  test('cooking time > 60 min.', () {
    var body = _body('test/testhtml/schneemoussetorte.html');
    var rd = RecipeDetail.fromDoc(RecipeDetailDocument(body));
    expect(rd.title, 'Schneemoussetorte mit Rhabarber');
    expect(rd.difficulty, 'normal');
    expect(rd.cookingtime, 'N/A');
  });
}
