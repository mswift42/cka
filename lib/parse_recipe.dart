import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

const CKPrefix = 'https://www.chefkoch.de';

class CKBody {
  String searchterm;
  String page;

  CKBody(this.searchterm, this.page);

  Future<String> getCKPage() async {
    http.Response response = await http.get(queryUrl());
    return response.body;
  }

  String queryUrl() {
    return '$CKPrefix/rs/s$page/$searchterm/Rezepte.html#more2';
  }
}

class CKDocument {
  String searchterm;
  String page;

  CKDocument(this.searchterm, this.page);

  Future<Document> getDoc() async {
    CKBody ck = CKBody(searchterm, page);
    String ckbody = await ck.getCKPage();
    return parse(ckbody);
  }


}

class CKDocSelection {
  Node cknode; 
  CKDocSelection(this.cknode);
}