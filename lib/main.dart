import 'package:cka/Recipe.dart';
import 'package:flutter/material.dart';
import 'package:cka/mockrecipes.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CK',
      theme: ThemeData(
        primaryColor: Colors.green[500],
        accentColor: Colors.lime[500],
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => RecipeSearch(),
        '/recipegrid': (context) =>
            RecipeGrid(SearchQuery("", 0), mockresultlist),
      },
    );
  }
}

class RecipeSearch extends StatefulWidget {
  @override
  _RecipeSearchState createState() => _RecipeSearchState();
}

class _RecipeSearchState extends State<RecipeSearch> {
  String searchquery = '';
  final controller = TextEditingController();

  void _setSearchQueryText() {
    searchquery = controller.text;
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_setSearchQueryText);
  }

  @override
  void dispose() {
    controller.removeListener(_setSearchQueryText);
    controller.dispose();
    super.dispose();
  }

  void _searchRecipe(String inp) {
    // Navigator.pushNamed(
    //   context, '/recipegrid',
    //   arguments: SearchQuery(searchquery, 120));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                RecipeGrid(SearchQuery(inp, 0), mockresultlist)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CK'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextField(
              controller: controller,
              onSubmitted: _searchRecipe,
            ),
          )
        ],
      ),
    );
  }
}

class RecipeGrid extends StatelessWidget {
  final SearchQuery searchQuery;
  final List<Recipe> recipes;

  RecipeGrid(this.searchQuery, this.recipes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(searchQuery.searchterm),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.extent(
              maxCrossAxisExtent: 480.00,
              children:
                  recipes.map((i) => RecipeSearchItem(recipe: i)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeSearchItem extends StatefulWidget {
  final Recipe recipe;

  RecipeSearchItem({this.recipe});

  @override
  _RecipeSearchItemState createState() => _RecipeSearchItemState();
}

class _RecipeSearchItemState extends State<RecipeSearchItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showRecipe(context),
      child: GridTile(
        child: Hero(
          tag: widget.recipe.thumbnail,
          child: CachedNetworkImage(
            imageUrl: widget.recipe.thumbnail,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(widget.recipe.title),
          subtitle: Text(widget.recipe.rating),
        ),
      ),
    );
  }
}
