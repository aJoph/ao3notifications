import 'package:ao3_scraper/ao3_scraper.dart';
import 'package:ao3notifications/helpers/change_username_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Ao3Model extends ChangeNotifier {
  String? _username;
  FlutterLocalNotificationsPlugin?
      flutterLocalNotificationsPlugin; // Init'ed in the init() function.

  /// Username used to fetch the bookmarks.
  /// If its value changes, updateLibrary is automatically called.
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

  /// Updates the bookmarks list in the Ao3Model, as well as the
  /// chapterTracker map. If an update is found, it will immediately be
  /// consumed.
  ///
  /// It will automatically fetch the local database for bookmarks and updated the
  /// chapterTracker map with it for the sake of comparing it for new updates.
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
      // Important: For some reason, this block of code is
      // executing twice during startup of the app.
      // So likely, updateLibrary is getting called twice.

      // So that if a user has deleted a bookmark, it is reflected here.
      await Hive.box<int>("bookmarks").clear();

      for (final _work in bookmarks) {
        Hive.box<int>("bookmarks").put(_work.workID, _work.numberOfChapters);
      }
    }

    notifyListeners();
  }

  /// consumeNotifications shows local notifications for the user that at least
  /// one of their bookmarks has received an updated.
  void consumeNotifications(List<int> notifications) async {
    debugPrint(
        "Notifications in consumeNotifications() " + notifications.toString());
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin!.show(0, 'Updates found.',
        '${notifications.length} found in bookmarks.', platformChannelSpecifics,
        payload: 'bookmarks');
  }

  /// Initializes the app's database as well as sets up
  /// local notifications.
  Future<void> init() async {
    // Init database
    await Hive.initFlutter();
    await Hive.openBox<String>("username");
    await Hive.openBox<int>("bookmarks");

    // Init local notifications plugin.
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const initializationSettingsMacOS = MacOSInitializationSettings(
        requestBadgePermission: false, requestSoundPermission: false);
    const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    final err = await flutterLocalNotificationsPlugin!.initialize(
      initializationSettings,
      onSelectNotification: (payload) {},
    );
    if (err != true) {
      throw (StateError(
          "Flutter local notifications plugin failed to initialize."));
    }
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
