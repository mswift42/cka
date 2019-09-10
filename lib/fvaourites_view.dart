import 'package:cka/recipe.dart';
import 'package:flutter/material.dart';

class FavouritesView extends StatefulWidget {
  final List<RecipeDetail> favourites;

  const FavouritesView({Key key, this.favourites}) : super(key: key);

  @override
  _FavouritesViewState createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favoriten"),
      ),
      body: GridView.extent(maxCrossAxisExtent: 480.00,
        children:
        widget.favourites.map((i) => Favourite(recipeDetail: i)).toList(),
      ),
    );
  }
}

class Favourite extends StatefulWidget {
  final RecipeDetail recipeDetail;

  Favourite({Key key, this.recipeDetail}) : super(key: key);

  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

