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
        updateLibrary();
      }
    }
    return _username ?? "";
  }

  set username(value) {
    _username = value;
    if (Hive.isBoxOpen("username")) {
      Hive.box("username").put("username", _username);
    }
    updateLibrary().whenComplete(() => notifyListeners());
  }

  bool hasReadBookmarksInStorage = false;
  var bookmarks = <Work>[];
  var chapterTracker = <int, int>{};

  Future<void> updateLibrary() async {
    // Read bookmarks in local storage.
    if (!hasReadBookmarksInStorage &&
        Hive.isBoxOpen("bookmarks") &&
        Hive.box("bookmarks").isNotEmpty) {
      final _bookmarksBox = Hive.box("bookmarks");

      // Getting the values in storage into the chapterTracker map.
      for (var i = 0; i < _bookmarksBox.length; i++) {
        final _workID = _bookmarksBox.values.elementAt(i);
        final _chapterCount = _bookmarksBox.get(_workID);
        chapterTracker[_workID] = _chapterCount;
      }

      hasReadBookmarksInStorage = true;
    }

    bookmarks = await Ao3Client.getBookmarksFromUsername(username);

    // Seeing what has been updated.
    var _newlyUpdated = <int>[];
    for (final bookmark in bookmarks) {
      // If there has been no update.
      if (chapterTracker.containsKey(bookmark.workID) &&
          chapterTracker[bookmark.workID] == bookmark.numberOfChapters) {
        continue;
      }

      // If there has been an update. Update the chapterTracker and add the WorkID
      // of the updated bookmark into _newlyUpdated to be consumed.
      chapterTracker[bookmark.workID] = bookmark.numberOfChapters;
      _newlyUpdated.add(bookmark.workID);
    }

    if (_newlyUpdated.isNotEmpty) consumeNotifications(_newlyUpdated);

    // Updating entries in database.
    if (Hive.isBoxOpen("bookmarks")) {
      for (final _work in bookmarks) {
        await Hive.box("bookmarks").clear();
        Hive.box("bookmarks").put(_work.workID, _work.numberOfChapters);
      }
    }

    notifyListeners();
  }

  void consumeNotifications(List<int> notifications) {
    // TODO: Implement consumeNotifications.
  }

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox("username");
    await Hive.openBox("bookmarks");
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
