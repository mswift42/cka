import 'package:cka/recipe.dart';

Future<List<Recipe>> fetchRecipes(SearchQuery searchQuery) async {
  var cdoc = CKDocument(searchQuery.searchterm, searchQuery.page.toString());
  var body = await cdoc.getDoc();
  return recipes(body);
}
