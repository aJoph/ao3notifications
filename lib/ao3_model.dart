import 'package:ao3_scraper/ao3_scraper.dart';
import 'package:ao3notifications/helpers/change_username_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Ao3Model extends ChangeNotifier {
  final _usernameBox = Hive.openBox("username");
  final _bookmarksBox = Hive.openBox("_bookmarks");

  String _username = "jdij";
  String get username {
    return _username;
  }

  set username(value) {
    _username = value;
    updateLibrary(_username);
    notifyListeners();
  }

  var bookmarks = <Work>[];

  void updateLibrary(String username) {
    Ao3Client.getBookmarksFromUsername(username)
        .then((value) => bookmarks = value)
        .whenComplete(
          () => notifyListeners(),
        );
  }

  static void init() {
    Hive.initFlutter();
    Hive.openBox("username");
    Hive.openBox("_bookmarks");
  }

  static void showChangeUsernameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const UsernameDialog();
      },
    );
  }
}
