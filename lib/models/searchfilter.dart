import 'package:cka/recipe_service.dart' show SearchFilter;
import 'package:flutter/material.dart';

class SearchFilterModel extends ChangeNotifier {
  static const _searchFilters = [
    SearchFilter("relevanz", ""),
    SearchFilter("bewertung", "o8"),
    SearchFilter("datum", "o3"),
  ];
}
