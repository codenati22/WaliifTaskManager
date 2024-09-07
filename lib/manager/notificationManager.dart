import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

class NotificationManager {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();

    await _requestExactAlarmPermission();
  }

  static Future<bool> _checkAndRequestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied || status.isLimited) {
      final newStatus = await Permission.notification.request();
      return newStatus.isGranted;
    }
    return false;
  }

  static Future<void> _requestExactAlarmPermission() async {
    if (Platform.isAndroid && (await _androidVersion()) >= 31) {
      final result = await Permission.scheduleExactAlarm.status;
      if (!result.isGranted) {
        await Permission.scheduleExactAlarm.request();
      }
    }
  }

  static Future<int> _androidVersion() async {
    return int.parse(Platform.operatingSystemVersion
        .split(" ")
        .firstWhere((s) => s.contains("."), orElse: () => "0")
        .split(".")
        .first);
  }

  static Future<void> scheduleNotification(
      DateTime dateTime, String taskId) async {
    final hasPermission = await _checkAndRequestNotificationPermission();
    if (!hasPermission) {
      print('Notification permission not granted.');
      return;
    }

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'task_channel_id',
      'Task Notifications',
      channelDescription: 'Notification channel for task reminders',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosPlatformChannelSpecifics = DarwinNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        int.parse(taskId),
        'Task Due Date',
        'Your task due date is today. Please check your task!',
        tz.TZDateTime.from(dateTime, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }
}
