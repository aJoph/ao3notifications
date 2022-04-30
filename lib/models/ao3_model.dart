import 'package:ao3_scraper/ao3_scraper.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Ao3Model extends ChangeNotifier {
  String? _username;
  get username {
    final usernameBox = Hive.box("username");
    if (usernameBox.isEmpty) {
      throw ("Username not in database."); // TODO: Ask someone if throwing an error in a getter is idiomatic.
    }
    _username = Hive.box("username").values.cast<String>().first;
    return _username;
  }

  set username(newValue) {
    _username = newValue;
    Hive.box("username").put("username", newValue);
    updateLibrary();
    // NotifyingListeners is not necessary since updateLibrary() already does that.
    // If that's no longer true... You know what to do.
  }

  var bookmarks = <Work>[];
  var bookmarksWithUpdates = <Work>[];

  /// Initiates the database for the app. Is a requirement for proper functioning of the app.
  static void init() {
    // TODO: Use shared preferences to store username data as Hive boxes have too heavy a cost to open.
    Hive.openBox("username");
    Hive.openBox("bookmarks");
  }

  void updateLibrary() {
    Ao3Client.getBookmarksFromUsername(username).then(
      (value) {
        for (var i = 0; i < bookmarks.length; i++) {
          // Bookmarks is being used for comparison because it will logically be smaller; this is to avoid out of range errors.
          if (bookmarks[i].numberOfChapters != value[i].numberOfChapters) {
            bookmarksWithUpdates.add(value[i]);
          }
        }
        bookmarks = value;
      },
    );

    notifyListeners();
  }

  void consumeNotifications() {
    // TODO: Implement notifications.

    bookmarksWithUpdates.clear();
  }
}
