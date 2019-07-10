import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Recipe {
  String title;
  String url;
  String thumbnail;
  String difficulty;
  String preptime;

  Recipe(this.title, this.url, this.thumbnail, this.difficulty, this.preptime);

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(json['title'], json['url'], json['thumbnail'],
        json['difficulty'], json['preptime']);
  }

  factory Recipe.fromCkDocSelection(CKDocSelection sel) {
    return Recipe(sel.title(), sel.url(), sel.thumbnail(), sel.difficulty(),
        sel.preptime());
  }
}

class RecipeDetail {
  String title;
  String rating;
  String difficulty;
  String preptime;
  String cookingtime;
  String resttime;
  String thumbnail;
  List<RecipeIngredient> ingredients;
  String method;

  RecipeDetail(
      {this.title,
      this.rating,
      this.difficulty,
      this.preptime,
      this.cookingtime,
      this.resttime,
      this.thumbnail,
      this.ingredients,
      this.method});

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    return RecipeDetail(
        title: json['title'],
        rating: json['rating'],
        difficulty: json['difficulty'],
        preptime: json['preptime'],
        cookingtime: json['cookingtime'],
        resttime: json['resttime'],
        thumbnail: json['thumbnail'],
        ingredients: json['ingredients'],
        method: json['method']);
  }

  factory RecipeDetail.fromDoc(RecipeDetailDocument doc) {
    var pi = doc._prepInfo();
    return RecipeDetail(
      title: doc.title(),
      rating: doc.rating(),
      difficulty: doc.difficulty(pi),
      preptime: doc.preptime(pi),
      cookingtime: doc.cookingtime(pi),
      resttime: doc.resttime(pi),
      thumbnail: doc.thumbnail(),
      ingredients: doc.ingredients(),
      method: doc.method(),
    );
  }
}

class RecipeIngredient {
  String amount;
  String ingredient;

  RecipeIngredient(this.amount, this.ingredient);
}

class SearchQuery {
  String searchterm;
  String page;

  SearchQuery(this.searchterm, this.page);
}

String nextPage(String currentPage) {
  var curr = int.tryParse(currentPage);
  if (curr == null) {
    return "";
  }
  return (curr + 30).toString();
}

String prevPage(String currentPage) {
  var curr = int.tryParse(currentPage);
  if (curr == null) {
    return "";
  }
  if (curr < 30) {
    return "0";
  }
  return (curr - 30).toString();
}

const CKPrefix = 'https://www.chefkoch.de';

class CKDocument {
  String searchterm;
  String page;

  CKDocument(this.searchterm, this.page);

  Future<String> getCKPage() async {
    http.Response response = await http.get(queryUrl());
    return response.body;
  }

  String queryUrl() {
    return '$CKPrefix/rs/s${page}o8/$searchterm/Rezepte.html';
  }

  Future<Document> getDoc() async {
    String ckbody = await getCKPage();
    return parse(ckbody);
  }
}

class CKDocSelection {
  Element cknode;

  CKDocSelection(this.cknode);

  String title() {
    return cknode.querySelector(".ds-heading-link").text;
  }

  String url() {
    var url = cknode.querySelector(".rsel-item > a");
    return url.attributes["href"];
  }

  String thumbnail() {
    var thumbs =
        cknode.querySelector(".ds-mb-left > amp-img").attributes["srcset"];
    var img = thumbs.split('\n')[2].trim().replaceFirst(' 3x', '');
    if (img.startsWith('//img')) {
      return 'https:$img';
    }
    return img;
  }

  String difficulty() {
    return cknode
        .querySelector(".recipe-difficulty")
        .text
        .split('\n')[1]
        .trim();
  }

  String preptime() {
    return cknode.querySelector(".recipe-preptime").text.split('\n')[1].trim();
  }
}

List<Recipe> recipes(Document doc) {
  var sels = doc.querySelectorAll('.rsel-item');
  return sels.map((i) => Recipe.fromCkDocSelection(CKDocSelection(i))).toList();
}

class RecipeDetailDocument {
  Document cdoc;

  RecipeDetailDocument(this.cdoc);

  String title() {
    return cdoc.querySelector(".page-title").text;
  }

  String rating() {
    var rat = cdoc.querySelector(".rating__average-rating").text;
    return rat.replaceFirst('ø', '').replaceAll(",", ".").substring(1);
  }

  Map<String, String> _prepInfo() {
    var result = Map<String, String>();
    var preptext = cdoc
        .querySelector("#preparation-info")
        .text
        .replaceAll("\n", "")
        .replaceAll("Koch-/Backzeit", "Kochzeit")
        .replaceAll("keine Angabe", "NA");
    var sections = preptext.split("/");
    sections.forEach((i) {
      var split = i.trim().split(":");
      result[split[0]] = split[1].trim();
    });
    return result;
  }

  String difficulty(Map pi) {
    return pi['Schwierigkeitsgrad'];
  }

  String preptime(Map pi) {
    return pi['Arbeitszeit'];
  }

  String cookingtime(Map pi) {
    return pi['Kochzeit'] ?? 'N/A';
  }

  String resttime(Map pi) {
    var ct = pi['Kochzeit'];
    if (ct == null) {
      return 'NA';
    }
    var sub = ct.indexOf("Ruhezeit");
    return ct.substring(sub);
  }

  String thumbnail() {
    return cdoc.querySelector('.slideshow-image').attributes['src'];
  }

  String method() {
    return cdoc.querySelector('#rezept-zubereitung').text.trim();
  }

  List<RecipeIngredient> ingredients() {
    var ingredients = List<RecipeIngredient>();
    var ingtable = cdoc.querySelectorAll('.incredients>tbody>tr');
    ingtable.forEach((i) {
      var amount = i.querySelector('.amount').text.trim();
      var ing = i.querySelector('td:last-child').text.trim();
      ingredients.add(RecipeIngredient(amount, ing));
    });
    return ingredients;
  }
}

Future<Document> getPage(String url) async {
  http.Response response = await http.get(url);
  return parse(response.body);
}
