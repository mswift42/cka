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
        '/recipegrid': (context) => RecipeGrid(),
      },
    );
  }
}

class RecipeSearch extends StatefulWidget {
  @override
  _RecipeSearchState createState() => _RecipeSearchState();
}

class _RecipeSearchState extends State<RecipeSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CK'),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}

class RecipeGrid extends StatelessWidget {
  @override
  final SearchQuery searchQuery;
  RecipeGrid(this.searchQuery);
  Widget build(BuildContext context) {
    return Container();
  }
}
