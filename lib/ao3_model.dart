import 'package:ao3_scraper/ao3_scraper.dart';
import 'package:ao3notifications/helpers/change_username_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Ao3Model extends ChangeNotifier {
  String? _username;
  String get username {
    if (_username == null || _username!.isEmpty) {
      if (Hive.isBoxOpen("username") && Hive.box("username").isNotEmpty) {
        _username = Hive.box("username").values.first;
        debugPrint("here i am");
        updateLibrary();
      }
    }
    return _username ?? "";
    // if ((_username == null || _username!.isEmpty) &&
    //     Hive.isBoxOpen("username")) {
    //   _username = Hive.box("username").get("username");
    //   Future.delayed(const Duration(seconds: 1)).whenComplete(() {
    //     // The delay is necessary to avoid recursively calling updateLibrary().
    //     if (bookmarks.isEmpty) updateLibrary();
    //   });
    // }
    // return _username ?? "";
  }

  set username(value) {
    _username = value;
    if (Hive.isBoxOpen("username")) {
      Hive.box("username").put("username", _username);
    }
    updateLibrary().whenComplete(() => notifyListeners());
  }

  var bookmarks = <Work>[];

  Future<void> updateLibrary() async {
    bookmarks = await Ao3Client.getBookmarksFromUsername(username);
    notifyListeners();
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
