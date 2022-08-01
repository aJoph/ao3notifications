import 'dart:convert';

import 'package:ao3_scraper/ao3_scraper.dart';
import 'package:ao3notifications/helpers/updated_bookmark.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PersistenceService {
  late final Box<String> usernameBox;
  late final Box<int> bookmarksBox;
  late final Box<String> notificationsBox;

  /// Used by the [updateLibrary()] function to check if the database has already been read.
  /// Should always be true after the first call to [updateLibrary()].
  bool hasReadBookmarksInStorage = false;
  bool initialized = false;

  Future<void> initDatabase() async {
    await Hive.initFlutter();
    usernameBox = await Hive.openBox<String>("username");
    bookmarksBox = await Hive.openBox<int>("bookmarks");
    notificationsBox = await Hive.openBox<String>("notifications");
    initialized = true;
  }

  String? get storedUsername {
    if (initialized == false || usernameBox.isEmpty) return null;

    return usernameBox.values.first;
  }

  void storeUsername(String username) {
    if (Hive.isBoxOpen("username")) {
      Hive.box<String>("username").put("username", username);
    }
  }

  void storeBookmarks(List<Work> bookmarks) async {
    if (Hive.isBoxOpen("bookmarks")) {
      // So that if a user has deleted a bookmark, it is reflected here.
      await Hive.box<int>("bookmarks").clear();

      for (final _work in bookmarks) {
        Hive.box<int>("bookmarks").put(_work.workID, _work.numberOfChapters);
      }
    }
  }

  static Future<List<UpdatedBookmark>> getStoredNotifications() async {
    final notifications = <UpdatedBookmark>[];
    for (final update in Hive.box<String>("notifications").values) {
      final notif = UpdatedBookmark.fromJson(jsonDecode(update));
      notifications.add(notif);
    }
    return notifications;
  }
}
