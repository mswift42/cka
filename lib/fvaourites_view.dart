import 'package:cka/favourite_model.dart';
import 'package:cka/main.dart';
import 'package:cka/recipe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class FavouritesView extends StatelessWidget {
  final List<RecipeDetail> favourites;

  const FavouritesView({Key key, this.favourites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FavouriteModel>(
      builder: (context, favourite, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Favoriten"),
          ),
          body: GridView.extent(
            maxCrossAxisExtent: 480.00,
            children:
                favourites.map((i) => Favourite(recipeDetail: i)).toList(),
          ),
        );
      },
    );
  }
}

class Favourite extends StatelessWidget {
  Favourite({Key key, this.recipeDetail, this.image}) : super(key: key);
  final RecipeDetail recipeDetail;
  final ImageProvider image;

  void _showFavourite(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return RecipeDetailView(
        context: context,
        recipeDetail: recipeDetail,
        image: image,
      );
    }));
  }

  void _onDeletePressed() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFavourite(context),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 4.0,
            left: 4.0,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: _onDeletePressed,
            ),
          ),
          GridTile(
            child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: image,
              fit: BoxFit.fitWidth,
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black54,
              title: Text(recipeDetail.title),
              subtitle: Text(
                  "Difficulty :${recipeDetail.difficulty} ,Cooking Time: ${recipeDetail.cookingtime} "),
            ),
          ),
        ],
      ),
    );
  }
}
