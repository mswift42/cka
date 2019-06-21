import 'package:cached_network_image/cached_network_image.dart';
import 'package:cka/image_chache.dart' show Icache;
import 'package:cka/mockrecipedetail.dart';
import 'package:cka/mockrecipes.dart';
import 'package:cka/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:transparent_image/transparent_image.dart';

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
                RecipeGrid(SearchQuery(searchquery, 0), mockresultlist)));
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

class RecipeGrid extends StatefulWidget {
  final SearchQuery searchQuery;
  final List<Recipe> recipes;

  RecipeGrid(this.searchQuery, this.recipes);

  @override
  _RecipeGridState createState() => _RecipeGridState();
}

class _RecipeGridState extends State<RecipeGrid> {
  bool bottomOfPage = false;
  bool topOfPage = false;
  ScrollController _controller = ScrollController();
  Listener listener = Listener();

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent) {
      setState(() {
        bottomOfPage = true;
      });
    }
    if (_controller.offset >= _controller.position.minScrollExtent &&
        widget.searchQuery.page > 1) {
      setState(() {
        topOfPage = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _showNextResults() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.searchQuery.searchterm),
      ),
      floatingActionButton: bottomOfPage
          ? FloatingActionButton(
              onPressed: _showNextResults,
              child: Icon(topOfPage ? Icons.arrow_back : Icons.arrow_forward),
            )
          : Container(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.extent(
              maxCrossAxisExtent: 480.00,
              controller: _controller,
              children: widget.recipes
                  .map((i) => RecipeSearchItem(recipe: i))
                  .toList(),
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
  Image image;
  Icache imageCache;

  void _showRecipe(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return _RecipeDetailView(recipeDetail: schupfnudel);
    }));
  }

  @override
  void initState() {
    super.initState();
    imageCache = new Icache();
    imageCache.cachedImage(widget.recipe.thumbnail).then((image) {
      setState(() {
        image = image;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showRecipe(context),
      child: GridTile(
        child: Hero(
          tag: widget.recipe.thumbnail,
          child: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: CachedNetworkImageProvider(widget.recipe.thumbnail),
            fit: BoxFit.fitWidth,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(widget.recipe.title),
          subtitle: Text("Difficulty: " +
              widget.recipe.difficulty +
              ", Preptime: " +
              widget.recipe.preptime),
        ),
      ),
    );
  }
}

class _RecipeInfoRow extends StatelessWidget {
  const _RecipeInfoRow({
    Key key,
    @required this.rowLabel,
    @required this.rowInfo,
    this.rowTextColor,
  }) : super(key: key);

  final String rowLabel;
  final String rowInfo;
  final Color rowTextColor;

  @override
  Widget build(BuildContext context) {
    TextStyle ts = TextStyle(color: rowTextColor);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 8.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(rowLabel, style: ts),
          ),
          Text(rowInfo, style: ts),
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
  PaletteGenerator generator;
  ImageProvider image;
  Color bgcolor;
  Color txtcolor;

  Future<void> _updatePaletteGenerator(ImageProvider image) async {
    generator = await PaletteGenerator.fromImageProvider(image);
    bgcolor = generator.lightVibrantColor.color;
    txtcolor = generator.lightVibrantColor.bodyTextColor;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    image =
        Image(image: CachedNetworkImageProvider(widget.recipeDetail.thumbnail))
            .image;
    _updatePaletteGenerator(image);
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    const double _kRecipeViewerMaxWidth = 460.0;
    final bool _fullWidth = _size.width < _kRecipeViewerMaxWidth;

    Widget _recipeIngredientsView() {
      return Container(
        color: bgcolor ?? Colors.white,
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                ),
                for (var ingredient in widget.recipeDetail.ingredients)
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            ingredient.amount + ' ',
                            style: TextStyle(color: txtcolor ?? Colors.black),
                          ),
                          Text(
                            ingredient.ingredient,
                            style: TextStyle(color: txtcolor ?? Colors.black),
                          ),
                        ],
                      )),
              ],
            ),
          ],
        ),
      );
    }

    Widget _recipeMethodView() {
      return Container(
        color: bgcolor ?? Colors.white,
        child: Column(
          children: <Widget>[
            CachedNetworkImage(
              fit: BoxFit.fitWidth,
              imageUrl: widget.recipeDetail.thumbnail,
              placeholder: (context, url) => CircularProgressIndicator(),
            ),
            SingleChildScrollView(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  widget.recipeDetail.method,
                  style: TextStyle(
                      color: generator?.lightMutedColor?.bodyTextColor ??
                          Colors.black),
                )),
          ],
        ),
      );
    }

    Widget _recipeInfoView() {
      return Container(
        color: generator?.lightVibrantColor?.color ?? Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0.5, 0, 0.5, 10.0),
              child: SizedBox(
                width: _fullWidth ? _size.width : _kRecipeViewerMaxWidth,
                height: _size.height / 3.0,
                child: CachedNetworkImage(
                  imageUrl: widget.recipeDetail.thumbnail,
                  fit: BoxFit.fitWidth,
                  placeholder: (context, url) => CircularProgressIndicator(),
                ),
              ),
            ),
            _RecipeInfoRow(
              rowLabel: "Difficulty",
              rowInfo: widget.recipeDetail.difficulty,
              rowTextColor: txtcolor ?? Colors.black,
            ),
            _RecipeInfoRow(
                rowLabel: "Rating",
                rowInfo: widget.recipeDetail.rating,
                rowTextColor: txtcolor ?? Colors.black),
            _RecipeInfoRow(
              rowLabel: "Preptime",
              rowInfo: widget.recipeDetail.preptime,
              rowTextColor: txtcolor ?? Colors.black,
            ),
            _RecipeInfoRow(
              rowLabel: "Cooking Time",
              rowInfo: widget.recipeDetail.cookingtime == ""
                  ? "N.A"
                  : widget.recipeDetail.cookingtime,
              rowTextColor: txtcolor ?? Colors.black,
            ),
          ],
        ),
      );
    }

    AppBar appBar = AppBar(
        title: Text(widget.recipeDetail.title),
        bottom: TabBar(tabs: <Widget>[
          Tab(icon: Icon(Icons.description)),
          Tab(icon: Icon(Icons.list)),
          Tab(icon: Icon(Icons.info)),
        ]));
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: appBar,
          body: TabBarView(
            children: <Widget>[
              _recipeMethodView(),
              _recipeIngredientsView(),
              _recipeInfoView(),
            ],
          )),
    );
  }
}
