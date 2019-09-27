import 'package:cka/recipe.dart';

Future<List<Recipe>> fetchRecipes(SearchQuery searchQuery) async {
  var cdoc = CKDocument(searchQuery.searchterm, searchQuery.page.toString(),
      searchQuery.searchFilter.abbrev);
  var body = await cdoc.getDoc();
  return recipes(body);
}

Future<RecipeDetail> fetchRecipeDetail(String url) async {
  var doc = await getPage(url);
  return RecipeDetail.fromDoc(RecipeDetailDocument(doc));
}

class SearchFilter {
  final String criterion;
  final String abbrev;

  const SearchFilter(this.criterion, this.abbrev);
}
