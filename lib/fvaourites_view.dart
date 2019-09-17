import 'package:cached_network_image/cached_network_image.dart';
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

  void _onDeletePressed() {
    setState(() {});
  }

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
              title: Text(widget.recipeDetail.title),
              subtitle: Text(
                  "Difficulty :${widget.recipeDetail.difficulty} ,Cooking Time: ${widget.recipeDetail.cookingtime} "),
            ),
          ),
        ],
      ),
    );
  }
}
