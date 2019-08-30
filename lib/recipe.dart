import 'package:cka/recipe_service.dart';
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
  String cookingtime;
  String thumbnail;
  List<RecipeIngredient> ingredients;
  String method;

  RecipeDetail(
      {this.title,
      this.rating,
      this.difficulty,
      this.cookingtime,
      this.thumbnail,
      this.ingredients,
      this.method});

//  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
//    return RecipeDetail(
//        title: json['title'],
//        rating: json['rating'],
//        difficulty: json['difficulty'],
//        cookingtime: json['cookingtime'],
//        thumbnail: json['thumbnail'],
//        ingredients: json['ingredients'],
//        method: json['method']);
//  }

  factory RecipeDetail.fromDoc(RecipeDetailDocument doc) {
    return RecipeDetail(
      title: doc.title(),
      rating: doc.rating(),
      difficulty: doc.difficulty(),
      cookingtime: doc.cookingtime(),
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
  SearchFilter searchFilter;

  SearchQuery(this.searchterm, this.page, this.searchFilter);
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
    return cdoc.querySelector('h1').text.trim();
  }

  String rating() {
    return cdoc.querySelector('.ds-rating-avg>strong').text.trim();
  }

  String difficulty() {
    return cdoc
        .querySelector('.recipe-difficulty')
        .text
        .replaceAll('\n', '')
        .replaceAll('', '')
        .trim();
  }

  String cookingtime() {
    var ct = cdoc.querySelector('.recipe-preptime').text;
    var split = ct.split('\n');
    return split[1].trim();
  }

  String thumbnail() {
    var thumbs = cdoc
        .querySelector('.bi-recipe-slider-open > amp-img')
        .attributes['srcset'];
    var img = thumbs.split('\n')[2].trim().replaceFirst(' 600w', '');
    return img;
  }

  String method() {
    return cdoc.querySelector('.rds-recipe-meta+.ds-box').text.trimLeft();
  }

  List<RecipeIngredient> ingredients() {
    var ingredients = List<RecipeIngredient>();
    var ingtable = cdoc.querySelectorAll('.ingredients>tbody>tr');
    ingtable.forEach((i) {
      var amount = i.querySelector('.td-left').text.trim();
      var amsplit = amount.split(' ');
      if (amsplit.length > 2) {
        amount = amsplit.first + ' ' + amsplit.last;
      }
      var ing = i.querySelector('.td-right').text.trim();
      ingredients.add(RecipeIngredient(amount, ing));
    });
    return ingredients;
  }
}

Future<Document> getPage(String url) async {
  http.Response response = await http.get(url);
  return parse(response.body);
}
