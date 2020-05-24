import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'create_notification.dart';
import 'notification_plugin.dart';
import 'notification_data.dart';


class notification extends StatefulWidget{
  @override
  _NotificationPageState createState() => _NotificationPageState();

}

class _NotificationPageState extends State<notification> {
  final NotificationPlugin _notificationPlugin = NotificationPlugin();
  Future<List<PendingNotificationRequest>> notificationFuture;

  @override
  void initState() {
    super.initState();
    notificationFuture = _notificationPlugin.getScheduledNotification();
  }

  @override
  Widget build(BuildContext context){
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Time'),
      ),

      body: new Column(
        children: <Widget>[
          FutureBuilder<List<PendingNotificationRequest>>(
              future:  notificationFuture,
              initialData: [],
              builder: (context, snapshot){
                final  notifications = snapshot.data;
                return Expanded(
                  child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        //return Text(notification.title);
                        return NotificationTile(
                          notification: notification,
                          deleteNotification: dismissNotification,
                        );
                      }
                  ),
                );
              }
          ),

        ],
      ),
    );
  }

  Future<void> dismissNotification(int id) async{
    await _notificationPlugin.cancelNotification(id);
    refreshNotification();
  }

  void refreshNotification(){
    setState(() {
      notificationFuture=_notificationPlugin.getScheduledNotification();
    });
  }

  Future<void> navigateToNotificationCreation() async {
    NotifcationData notificationDate = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => create_notification(),
        )
    );

    if (notificationDate != null) {
      final notificationList = await _notificationPlugin.getScheduledNotification();
      int id = 0;
      for (var i = 0; i < 100; i++) {
        bool exists = _notificationPlugin.checkIfIdExists(notificationList, i);
        if (!exists) {
          id = i;
        }
      }

      await _notificationPlugin.showDailyAtTime(
        notificationDate.time,
        id,
        notificationDate.title,
        notificationDate.description,
      );
      setState(() {
        notificationFuture = _notificationPlugin.getScheduledNotification();
      });
    }
  }
}
class NotificationTile extends StatelessWidget{
  const NotificationTile({
    Key key,
    @required this.notification,
    @required this.deleteNotification,

  }): super(key: key);

  final PendingNotificationRequest notification;
  final Function(int id) deleteNotification;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(notification.title),
        subtitle: Text(notification.body),
        trailing: IconButton(
          onPressed: ()=> deleteNotification(notification.id),
          icon: Icon(Icons.delete),
        ),
      ),
    );
  }
}