import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Recipe {
  String title;
  String subtitle;
  String url;
  String thumbnail;
  String rating;
  String difficulty;
  String preptime;

  Recipe(this.title, this.subtitle, this.url, this.thumbnail, this.rating,
      this.difficulty, this.preptime);

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
        json['title'],
        json['subtitle'],
        json['url'],
        json['thumbnail'],
        json['rating'],
        json['difficulty'],
        json['preptime']);
  }
}

class RecipeDetail {
  String title;
  String rating;
  String difficulty;
  String preptime;
  String cookingtime;
  String thumbnail;
  List<RecipeIngredient> ingredients;
  String method;

  RecipeDetail(
      {this.title,
      this.rating,
      this.difficulty,
      this.preptime,
      this.cookingtime,
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
        thumbnail: json['thumbnail'],
        ingredients: json['ingredients'],
        method: json['method']);
  }
}

class RecipeIngredient {
  String amount;
  String ingredient;

  RecipeIngredient(this.amount, this.ingredient);
}

class SearchQuery {
  String searchterm;
  int page;

  SearchQuery(this.searchterm, this.page);
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
    return '$CKPrefix/rs/s$page/$searchterm/Rezepte.html#more2';
  }


  Future<Document> getDoc() async {
    String ckbody = await getCKPage();
    return parse(ckbody);
  }
}

class CKDocSelection {
  Node cknode;

  CKDocSelection(this.cknode);
}
