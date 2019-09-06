import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FavouriteService {
  final String _favouritesFile = 'favourites.txt';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_favouritesFile');
  }

  Future<File> writeFavourites(List<Map<String,dynamic>> favourites) async {
    final file = await _localFile;
    String json = jsonEncode(favourites);
    return file.writeAsString(json);
  }
}