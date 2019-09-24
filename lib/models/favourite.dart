import 'dart:collection';

import 'package:cka/recipe.dart' show RecipeDetail;
import 'package:flutter/material.dart';

class FavouriteModel extends ChangeNotifier {
  final List<RecipeDetail> _favourites = [];

  UnmodifiableListView<RecipeDetail> get favouites =>
      UnmodifiableListView(_favourites);

  void delete(RecipeDetail favourite) {
    _favourites.remove(favourite);
    notifyListeners();
  }
}
