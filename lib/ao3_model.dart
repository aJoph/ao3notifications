import 'package:ao3_scraper/ao3_scraper.dart';
import 'package:ao3notifications/helpers/change_username_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Ao3Model extends ChangeNotifier {
  final _usernameBox = Hive.openBox("username");
  final _bookmarksBox = Hive.openBox("bookmarks");

  String? _username;
  String get username {
    return _username ?? "";
  }

  set username(String newValue) {
    _username = newValue;
    updateLibrary(_username!);
  }

  var bookmarks = <Work>[];

  void updateLibrary(String username) {
    if (_username == null || _username!.isEmpty || _username == "") {
      throw ("No username");
    }
    Ao3Client.getBookmarksFromUsername(_username!).then((value) {
      bookmarks = value;
      notifyListeners();
      debugPrint(bookmarks.toString());
    });
  }

  static void init() {
    Hive.initFlutter();
    Hive.openBox("username");
    Hive.openBox("bookmarks");
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
