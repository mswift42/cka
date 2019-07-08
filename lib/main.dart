import 'package:cached_network_image/cached_network_image.dart';
import 'package:cka/recipe.dart';
import 'package:cka/recipe_service.dart';
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
        primaryColor: Colors.lime[200],
        accentColor: Colors.lime[100],
        primarySwatch: Colors.lightGreen,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => RecipeSearch(),
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
  String currentPage = "0";
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
    SearchQuery sq = SearchQuery(searchquery, currentPage);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              _showResultsBody(fetchRecipes(sq), sq, _handleTap)),
    );
  }

  void _handleTap(String page) {
    setState(() {
      currentPage = page;
    });
    _searchRecipe(searchquery);
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

FutureBuilder<List<Recipe>> _showResultsBody(
    Future<List<Recipe>> handler, SearchQuery sq, ValueChanged<String> cb) {
  return FutureBuilder(
    future: handler,
    builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return Container(child: Center(child: Text("Please try again.")));
        case ConnectionState.active:
        case ConnectionState.waiting:
          return Container(child: Center(child: CircularProgressIndicator()));
        case ConnectionState.done:
          if (snapshot.hasError) {
            return Text("Something went wrong: ${snapshot.error}");
          }
          return RecipeGrid(sq, snapshot.data, cb);
      }
    },
  );
}

FutureBuilder<RecipeDetail> _showRecipeDetailBody(
    Future<RecipeDetail> handler, ImageProvider image) {
  return FutureBuilder(
    future: handler,
    builder: (BuildContext context, AsyncSnapshot<RecipeDetail> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return Container(child: Center(child: Text("Please try again.")));
        case ConnectionState.active:
        case ConnectionState.waiting:
          return Container(child: Center(child: CircularProgressIndicator()));
        case ConnectionState.done:
          if (snapshot.hasError) {
            return Text("Something went wrong: ${snapshot.error}");
          }
          return _RecipeDetailView(
              context: context, recipeDetail: snapshot.data, image: image);
      }
    },
  );
}

class RecipeGrid extends StatefulWidget {
  final SearchQuery searchQuery;
  final List<Recipe> recipes;
  final ValueChanged<String> onChanged;

  RecipeGrid(this.searchQuery, this.recipes, this.onChanged);

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
        widget.searchQuery.page != "0") {
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

  void _showNextResults() {
    if (topOfPage) {
      widget.onChanged(prevPage(widget.searchQuery.page));
    } else {
      widget.onChanged(nextPage(widget.searchQuery.page));
    }
  }

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
  ImageProvider image;

  void _showRecipe(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return _showRecipeDetailBody(fetchRecipeDetail(widget.recipe.url), image);
    }));
  }

  @override
  void initState() {
    super.initState();
    image = CachedNetworkImageProvider(widget.recipe.thumbnail);
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
            image: image,
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
  final ImageProvider image;

  _RecipeDetailView({this.context, this.recipeDetail, this.image});

  @override
  __RecipeDetailViewState createState() => __RecipeDetailViewState();
}

class __RecipeDetailViewState extends State<_RecipeDetailView> {
  PaletteGenerator generator;
  Color bgcolor;
  Color txtcolor;
  ScrollController _controller = ScrollController();
  bool topOfPage = true;
  Duration _duration = Duration(milliseconds: 1000);

  _scrollListener() {
    if (_controller.offset > 40.0) {
      setState(() {
        topOfPage = false;
      });
    }
  }

  Future<void> _updatePaletteGenerator(ImageProvider image) async {
    generator = await PaletteGenerator.fromImageProvider(image);
    bgcolor = generator.lightVibrantColor.color;
    txtcolor = generator.lightVibrantColor.bodyTextColor;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _updatePaletteGenerator(widget.image);
    _controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    const double _kRecipeViewerMaxWidth = 460.0;
    final bool _fullWidth = _size.width < _kRecipeViewerMaxWidth;

    Widget _recipeIngredientsView() {
      return AnimatedContainer(
        duration: _duration,
        color: bgcolor ?? Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (var ingredient in widget.recipeDetail.ingredients)
                    new _IngredientsLine(
                        ingredient: ingredient, txtcolor: txtcolor),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _recipeMethodView() {
      return AnimatedContainer(
        duration: _duration,
        color: bgcolor ?? Colors.white,
        child: Column(
          children: <Widget>[
            buildFadeInImage(_size),
            Expanded(
              child: SingleChildScrollView(
                  controller: _controller,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    widget.recipeDetail.method,
                    style: TextStyle(color: txtcolor ?? Colors.black),
                  )),
            ),
          ],
        ),
      );
    }

    Widget _recipeInfoView() {
      return AnimatedContainer(
        duration: _duration,
        color: bgcolor ?? Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0.5, 0, 0.5, 10.0),
              child: SizedBox(
                width: _fullWidth ? _size.width : _kRecipeViewerMaxWidth,
                height: _size.height / 3.0,
                child: FadeInImage(
                  image: widget.image,
                  fit: BoxFit.fitWidth,
                  placeholder: MemoryImage(kTransparentImage),
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
        iconTheme: IconThemeData(color: txtcolor ?? Colors.white),
        backgroundColor: bgcolor ?? Colors.lightGreen,
        textTheme: TextTheme(title: TextStyle(color: txtcolor ?? Colors.white)),
        bottom: TabBar(tabs: <Widget>[
          Tab(
              icon: Icon(
            Icons.description,
            color: txtcolor ?? Colors.white,
          )),
          Tab(icon: Icon(Icons.list, color: txtcolor ?? Colors.white)),
          Tab(icon: Icon(Icons.info, color: txtcolor ?? Colors.white)),
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

  Widget buildFadeInImage(Size size) {
    return Container(
      width: size.width,
      constraints: BoxConstraints(
        maxHeight: size.height / 2.4,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
        child: Visibility(
          visible: topOfPage,
          child: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: widget.image,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}

class _IngredientsLine extends StatelessWidget {
  const _IngredientsLine({
    Key key,
    @required this.ingredient,
    @required this.txtcolor,
  }) : super(key: key);

  final RecipeIngredient ingredient;
  final Color txtcolor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
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
        ),
      ),
    );
  }
}
