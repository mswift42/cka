import 'dart:async';
import 'dart:io' show File;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCache {
  Future<File> findPath(String imageUrl) async {
    var file = await DefaultCacheManager().getSingleFile(imageUrl);
    return file;
  }
}
