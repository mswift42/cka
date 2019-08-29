import 'package:cka/recipe.dart';

Future<List<Recipe>> fetchRecipes(SearchQuery searchQuery) async {
  var cdoc = CKDocument(searchQuery.searchterm, searchQuery.page.toString());
  var body = await cdoc.getDoc();
  return recipes(body);
}

Future<RecipeDetail> fetchRecipeDetail(String url) async {
  var doc = await getPage(url);
  return RecipeDetail.fromDoc(RecipeDetailDocument(doc));
}

class SearchFilter {
  String criterion;

  SearchFilter(this.criterion);
}
