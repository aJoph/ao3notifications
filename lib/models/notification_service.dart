import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();
  late final InitializationSettings initSettings;
  bool initialized = false;

  NotificationService();

  Future<bool> initNotifications() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');

    const initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const initializationSettingsMacOS = MacOSInitializationSettings(
        requestBadgePermission: false, requestSoundPermission: false);

    const initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: "Ao3");

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
      linux: initializationSettingsLinux,
    );

    return await notificationPlugin.initialize(
          initializationSettings,
          onSelectNotification: (payload) {},
        ) ??
        false;
  }

  void consumeNotifications(int numOfUpdates) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '0',
      'bookmarks',
      channelDescription: 'Android channel for bookamrks.',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ticker: 'ticker',
      icon: '@mipmap/ao3logo',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final updateText = numOfUpdates == 1 ? "update" : "updates";
    notificationPlugin.show(
      0,
      'Updates found.',
      '$numOfUpdates new $updateText found in bookmarks',
      platformChannelSpecifics,
      payload: 'bookmarks',
    );
  }

  void showNotifications() {}
}
