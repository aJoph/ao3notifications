import 'dart:convert';

import 'package:ao3_scraper/ao3_scraper.dart';
import 'package:ao3notifications/helpers/updated_bookmark.dart';
import 'package:ao3notifications/models/notification_service.dart';
import 'package:ao3notifications/models/persistence_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Ao3Model extends ChangeNotifier {
  final notifService = NotificationService();
  final persistService = PersistenceService();

  /// The Ao3 bookmarks in memory. Is populated by the updateLibrary() function.
  var bookmarks = <Work>[];
  var notifications = <UpdatedBookmark>[];

  /// A map between workID and the chapterCount of the corresponding work.
  ///
  /// The updateLibrary() function will use this map to check if there has been an update.
  var chapterTracker = <int, int>{};

  String? _username;

  /// Username used to fetch the bookmarks.
  /// If its value changes, updateLibrary is automatically called.
  String? get username {
    // Checking if there's a value in local storage that could be used.
    if (_username == null || _username!.isEmpty) {
      _username = persistService.storedUsername;
    }

    return _username;
  }

  set username(value) {
    _username = value;
    persistService.storeUsername(_username!);

    // Clearing the bookmarks in memory, otherwise a notification will be sent
    // simply for changing to another username.
    bookmarks.clear();
    chapterTracker.clear();
    notifications.clear();

    if (persistService.initialized) {
      updateLibrary().whenComplete(() => notifyListeners());
    }
  }

  /// initFuture is a variable meant to store the value of init().
  /// Then, in FutureBuilder, the future property is set to watch initFuture, which is final.
  /// This minimizes the rebuilds the app undergoes.
  late final initFuture = () async {
    // Init
    await persistService.initDatabase();
    await notifService.initNotifications();

    // Getting the data into memory.
    updateLibrary();

    notifications = await PersistenceService.getStoredNotifications();

    return true;
  }.call();

  /// Updates the bookmarks list in the Ao3Model, as well as the
  /// chapterTracker map. If an update is found, it will immediately be
  /// consumed.
  ///
  /// It will automatically fetch the local database for bookmarks and updated the
  /// chapterTracker map with it for the sake of comparing it for new updates.
  ///
  /// Returns the amount of updates found.
  Future<int> updateLibrary() async {
    if (username == null) return 0;

    // Read bookmarks in local storage on first app startup.
    _fetchLocalUpdates();

    bookmarks = await Ao3Client.getBookmarksFromUsername(username!);

    // Seeing what has been updated.
    var _newlyUpdated = _updateChapterTracker();
    if (_newlyUpdated.isNotEmpty) {
      notifService.consumeNotifications(_newlyUpdated.length);
    }

    persistService.storeBookmarks(bookmarks);

    notifyListeners();

    return _newlyUpdated.length;
  }

  static void ao3launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) throw 'Could not launch $_url';
  }

  static Future<bool> checkUsernameValid(String username) async {
    final req = http.Request(
      "GET",
      Uri(
        scheme: 'https',
        host: 'archiveofourown.org',
        path: 'users/$username/',
      ),
    )..followRedirects = false;

    final resp = await req.send();
    return resp.statusCode == 200 ? true : false;
  }

  /// Gets the information in local storage to update the state.
  void _fetchLocalUpdates() {
    // Checking if persistence is ready; and then if there's anything to do.
    if (!persistService.initialized || persistService.bookmarksBox.isEmpty) {
      return;
    }

    final _bookmarksBox = persistService.bookmarksBox;

    // Getting the values in storage into the chapterTracker map,
    // so checking if there has been an update is easier.
    for (var i = 0; i < _bookmarksBox.length; i++) {
      final _workID = _bookmarksBox.keys.elementAt(i);
      final _chapterCount = _bookmarksBox.get(_workID);
      chapterTracker[_workID] = _chapterCount ?? 1;
    }

    persistService.hasReadBookmarksInStorage = true;
  }

  /// Helper function to used by updateLibrary() to identify what has changed
  /// from one updateLibrary call to another.
  List<int> _updateChapterTracker() {
    final updates = <int>[];

    for (final bookmark in bookmarks) {
      final oldChapterCount = chapterTracker[bookmark.workID];

      // If there has been no update.
      if (chapterTracker.containsKey(bookmark.workID) &&
          oldChapterCount == bookmark.numberOfChapters) {
        continue;
      }

      // If there has been an update: Update the chapterTracker and add the WorkID
      // of the updated bookmark into _newlyUpdated to be consumed.
      final _update = UpdatedBookmark(
        title: bookmark.title,
        author: bookmark.author,
        link: Ao3Client.getURLfromWorkID(bookmark.workID),
        updateCount: bookmark.numberOfChapters - (oldChapterCount ?? 0),
      );

      notifications.insert(0, _update);

      Hive.box<String>("notifications").add(jsonEncode(_update.toJson()));

      chapterTracker[bookmark.workID] = bookmark.numberOfChapters;
      updates.add(bookmark.workID);
    }

    return updates;
  }
}
