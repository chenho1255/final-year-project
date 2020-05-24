import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPlugin {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationPlugin() {
    _initializeNotifcations();
  }


  void _initializeNotifcations() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future onSelectNotification(String payload) async{
    if(payload!=null){
      print('notification payload: ' +payload);
    }
  }

  Future<void> showDailyAtTime(Time time, int id, String title, String description) async{
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'show weekly channel id',
      'show weekly channel name',
      'show weekly description',
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.showDailyAtTime(
        id,
        title,
        description,
        time,
        platformChannelSpecifics
    );

  }

  Future<void> showWeeklyAtDayAndTime(Time time, Day day, int id, String title,String decscription) async{
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'show weekly channel id',
      'show weekly channel name',
      'show weekly description',
    );

    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        id,
        title,
        decscription,
        day,
        time,
        platformChannelSpecifics
    );
  }

  Future<List<PendingNotificationRequest>> getScheduledNotification() async{
    final pendingNotifications = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications;
  }

  Future cancelNotification(int id)async{
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  bool checkIfIdExists(List<PendingNotificationRequest> notificationList, int i) {
    {
      for (final notification in notificationList) {
      if (notification.id == i) {
      return true;
      }
      }
      return false;
    }
  }




}