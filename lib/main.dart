import 'package:cached_network_image/cached_network_image.dart';
import 'package:cka/Recipe.dart';
import 'package:cka/mockrecipedetail.dart';
import 'package:cka/mockrecipes.dart';
import 'package:flutter/material.dart';

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
  void _showRecipe(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      AppBar appBar = AppBar(title: Text(widget.recipe.title));
      return Scaffold(
          appBar: appBar,
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0.5,
              vertical: 0.2,
            ),
            child: Hero(
              tag: widget.recipe.thumbnail,
              child: _RecipeViewer(recipe: widget.recipe),
            ),
          ));
    }));
  }

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

class _RecipeViewer extends StatefulWidget {
  final Recipe recipe;

  _RecipeViewer({this.recipe});

  @override
  __RecipeViewerState createState() => __RecipeViewerState();
}

class __RecipeViewerState extends State<_RecipeViewer> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    const double _kRecipeViewerMaxWidth = 460.0;
    final bool _fullWidth = _size.width < _kRecipeViewerMaxWidth;
    return GestureDetector(
      onTap: () => _showRecipeDetail(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: _size.height,
          maxWidth: _fullWidth ? _size.width : _kRecipeViewerMaxWidth,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: _size.height / 1.8,
                minWidth: _fullWidth ? _size.width : _kRecipeViewerMaxWidth,
              ),
              child: CachedNetworkImage(
                imageUrl: widget.recipe.thumbnail,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _recipeViewInfoRow("Rating", widget.recipe.rating),
                  _recipeViewInfoRow("Difficulty: ", widget.recipe.difficulty),
                  _recipeViewInfoRow("Preptime: ", widget.recipe.preptime),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRecipeDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return _RecipeDetailView(
            context: context, recipeDetail: grueneImSpeckMantel);
      }),
    );
  }

  Widget _recipeViewInfoRow(String rowLabel, String rowInfo) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 8.0,
      ),
      child: Row(
        children: <Widget>[
          Text(rowLabel),
          Text(rowInfo),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

class _RecipeDetailView extends StatefulWidget {
  final BuildContext context;
  final RecipeDetail recipeDetail;

  _RecipeDetailView({this.context, this.recipeDetail});

  @override
  __RecipeDetailViewState createState() => __RecipeDetailViewState();
}

class __RecipeDetailViewState extends State<_RecipeDetailView> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    const double _kRecipeViewerMaxWidth = 460.0;
    final bool _fullWidth = _size.width < _kRecipeViewerMaxWidth;
    AppBar appBar = AppBar(
        title: Text(widget.recipeDetail.title),
        bottom: TabBar(tabs: <Widget>[
          Tab(icon: Icon(Icons.info)),
          Tab(icon: Icon(Icons.list)),
          Tab(icon: Icon(Icons.description)),
        ]));
    return Scaffold(
        appBar: appBar,
        body: Column(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: _size.height / 2.0,
                minWidth: _fullWidth ? _size.width : _kRecipeViewerMaxWidth,
              ),
              child: CachedNetworkImage(
                imageUrl: widget.recipeDetail.thumbnail,
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ));
  }
}
