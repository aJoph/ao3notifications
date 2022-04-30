import 'package:ao3_scraper/ao3_scraper.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Ao3Model extends ChangeNotifier {
  String? _username;
  get username {
    return _username;
  }

  final bookmarks = <Work>[];

  /// Initiates the database for the app. Is a requirement for proper functioning of the app.
  static void init() {
    Hive.openBox("username");
    Hive.openBox("bookmarks");
  }
}
