import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifcationData{
  String title;
  String description;
  Time time;

  NotifcationData(this.title,this.description, this.time);
}