import 'dart:async';

import 'package:cka/last_search_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LastSearchModel extends ChangeNotifier {
  List<String> _savedSearches = [];
  void lastSearches() async {
    var searchService = LastSearchService();
    var searches = await searchService.readSearches();
    _savedSearches = searches;
  }

  List<String> get searches => _savedSearches;

  void add(String search) {
    _savedSearches.add(search);
    notifyListeners();
  }

  void remove(String search) {
    _savedSearches.remove(search);
    notifyListeners();
  }
}
