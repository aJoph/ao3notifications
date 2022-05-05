import 'package:ao3_scraper/ao3_scraper.dart';
import 'package:ao3notifications/helpers/change_username_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Ao3Model extends ChangeNotifier {
  String? _username;
  String get username {
    if (_username == null || _username!.isEmpty) {
      if (Hive.isBoxOpen("username") &&
          Hive.box<String>("username").isNotEmpty) {
        _username = Hive.box<String>("username").values.first;
        updateLibrary();
      }
    }
    return _username ?? "";
  }

  set username(value) {
    _username = value;
    if (Hive.isBoxOpen("username")) {
      Hive.box<String>("username").put("username", _username ?? "");
    }
    updateLibrary().whenComplete(() => notifyListeners());
  }

  bool hasReadBookmarksInStorage = false;
  var bookmarks = <Work>[];
  var chapterTracker = <int, int>{};

  Future<void> updateLibrary() async {
    // Read bookmarks in local storage on first app startup.
    if (!hasReadBookmarksInStorage &&
        Hive.isBoxOpen("bookmarks") &&
        Hive.box<int>("bookmarks").isNotEmpty) {
      final _bookmarksBox = Hive.box<int>("bookmarks");
      debugPrint("Entries in _bookmarksBox: " +
          _bookmarksBox.values.length.toString());

      // Getting the values in storage into the chapterTracker map,
      // so checking if there has been an update is easier.
      for (var i = 0; i < _bookmarksBox.length; i++) {
        final _workID = _bookmarksBox.keys.elementAt(i);
        final _chapterCount = _bookmarksBox.get(_workID);
        chapterTracker[_workID] = _chapterCount ?? 1;
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

      // If there has been an update: Update the chapterTracker and add the WorkID
      // of the updated bookmark into _newlyUpdated to be consumed.
      chapterTracker[bookmark.workID] = bookmark.numberOfChapters;
      _newlyUpdated.add(bookmark.workID);
    }

    if (_newlyUpdated.isNotEmpty) consumeNotifications(_newlyUpdated);

    // Updating entries in database.
    if (Hive.isBoxOpen("bookmarks")) {
      await Hive.box<int>("bookmarks").clear();
      for (final _work in bookmarks) {
        Hive.box<int>("bookmarks").put(_work.workID, _work.numberOfChapters);
      }
    }

    notifyListeners();
  }

  void consumeNotifications(List<int> notifications) {
    // TODO: Implement consumeNotifications.
    debugPrint(
        "Notifications in consumeNotifications() " + notifications.toString());
  }

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>("username");
    await Hive.openBox<int>("bookmarks");
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
