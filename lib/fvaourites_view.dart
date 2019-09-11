import 'package:cached_network_image/cached_network_image.dart';
import 'package:cka/main.dart';
import 'package:cka/recipe.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

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
      body: GridView.extent(
        maxCrossAxisExtent: 480.00,
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
  ImageProvider image;

  @override
  void initState() {
    super.initState();
    image = CachedNetworkImageProvider(widget.recipeDetail.thumbnail);
  }

  void _showFavourite(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return RecipeDetailView(
        context: context,
        recipeDetail: widget.recipeDetail,
        image: image,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFavourite(context),
      child: GridTile(
        child: FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: image,
          fit: BoxFit.fitWidth,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(widget.recipeDetail.title),
          subtitle: Text(
              "Difficulty :${widget.recipeDetail.difficulty} ,Cooking Time: ${widget.recipeDetail.cookingtime} "),
        ),
      ),
    );
  }
}
