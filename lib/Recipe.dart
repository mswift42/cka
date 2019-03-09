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
