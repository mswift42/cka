import 'package:http/http.dart' as http;

const CKPrefix = 'https://www.chefkoch.de';

class ParseRecipes {
  String searchterm;
  String page;

  ParseRecipes(this.searchterm, this.page);

  Future<String> getCKPage() async {
    http.Response response = await http.get(queryUrl());
    return response.body;
  }

  String queryUrl() {
    return '$CKPrefix/rs/s$page/$searchterm/Rezepte.html#more2';
  }
}
