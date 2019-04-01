import 'dart:async';
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Icache {
  Future<File> _getImageFile(String imageUrl) async {
    var file = await DefaultCacheManager().getSingleFile(imageUrl);
    return file;
  }

  Future<Image> cachedImage(String imageUrl) async {
    var file = await _getImageFile(imageUrl);
    return Image.file(file);
  }
}
