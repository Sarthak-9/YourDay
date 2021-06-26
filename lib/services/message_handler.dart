import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsHelper {

  static final _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

//needs an icon
  static final _initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');//ydnotif

  static final _initializationSettings =
  InitializationSettings(android: _initializationSettingsAndroid);

  static Future<void> init() async {
    await _flutterLocalNotificationsPlugin.initialize(_initializationSettings);
    tz.initializeDatabase([]);
  }


  static final _androidNotificationDetails = AndroidNotificationDetails(
    'channel id',
    'channel name',
    'channel description',
    importance: Importance.max,
    priority: Priority.high,
    color: const Color(0xFF305496)
  );

  static final _notificationDetails =
  NotificationDetails(android: _androidNotificationDetails);

// set Notification methoud
  static Future<void> setNotification(DateTime currentTime, int id,String title, String body) async {
    // final scheduledDate = tz.TZDateTime.from(dateTime, location);
    // await _flutterLocalNotificationsPlugin.periodicallyShow(id, title, body, RepeatInterval., notificationDetails)
    int dtYear = DateTime.now().year;
    // DateTime currentTime = dateTime;
    DateTime dt=currentTime;
    DateTime dtnow = DateTime.now();
    // if(currentTime.year==dtnow.year&&currentTime.month==dtnow.month&&currentTime.day==dtnow.day){
    //   dt = DateTime(dtnow.year,currentTime.month,currentTime.day);
    //
    // }else
      if(dt.isAfter(dtnow)){
      dt = currentTime;
    }
    else{
      if(currentTime.isBefore(dtnow)){
        dt = DateTime(dtnow.year,currentTime.month,currentTime.day);
        // if(currentTime.month<dtnow.month||currentTime.day<dtnow.day){
        //   calyear++;
        // }
      }
      if(dt.isBefore(dtnow)){
        dt = DateTime(dtnow.year+1,currentTime.month,currentTime.day);
      }
    }
    for(int i=0;i<10;i++){
      DateTime notifTime = DateTime(dt.year+i,dt.month,dt.day,dt.hour,dt.minute);
      // print(notifTime);
     // await _flutterLocalNotificationsPlugin
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id+i,
        title,
        body,
        // dateTime,
        tz.TZDateTime.from(notifTime, tz.local),
        _notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  static Future<void> setNotificationForTask(DateTime currentTime, int id,String title, String body) async {

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        // dateTime,
        tz.TZDateTime.from(currentTime, tz.local),
        _notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
  }

// cancel Notification methoud
  static Future<void> cancelNotification(int id) async {
    for(int i=0;i<10;i++) {
      await _flutterLocalNotificationsPlugin.cancel(id+i);
    }
  }
  static Future<void> cancelTaskNotification(int id) async {
      await _flutterLocalNotificationsPlugin.cancel(id);

  }

  static Future<void> showNotif()async{
    await _flutterLocalNotificationsPlugin.show(
        12345,
        "A Notification From My Application",
        "This notification was sent using Flutter Local Notifcations Package",
        _notificationDetails,
        payload: 'data');
  }
}

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'dart:io';
//
// import 'package:googleapis/storage/v1.dart';
// class MessageHandler extends StatefulWidget {
//   const MessageHandler({Key key}) : super(key: key);
//
//   @override
//   _MessageHandlerState createState() => _MessageHandlerState();
// }
//
// class _MessageHandlerState extends State<MessageHandler> {
//   FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   // FirebaseMessaging _messaging;
//
//   void registerNotification() async {
//     PushNotification _notificationInfo;
//     // ...
//
//     // For handling the received notifications
//     _messaging.sendMessage(
//       onMessage: (message) async {
//         print('onMessage received: $message');
//
//         // Parse the message received
//         PushNotification notification = PushNotification.fromJson(message);
//
//         setState(() {
//           _notificationInfo = notification;
//           // _totalNotifications++;
//         });
//       },
//     );
//     // 1. Initialize the Firebase app
//     // await Firebase.initializeApp();
//     //
//     // 2. On iOS, this helps to take the user permissions
//     // await _messaging..requestPermissions(
//     //   Notificationio===(
//     //     alert: true,
//     //     badge: true,
//     //     provisional: false,
//     //     sound: true,
//     //   ),
//     // );
//
//     // TODO: handle the received notifications
//   }
//   // void pushNotification()async{
//   //   NotificationSettings settings = await messaging.requestPermission(
//   //     alert: true,
//   //     announcement: false,
//   //     badge: true,
//   //     carPlay: false,
//   //     criticalAlert: false,
//   //     provisional: false,
//   //     sound: true,
//   //   );
//   //
//   //   print('User granted permission: ${settings.authorizationStatus}');
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//
//     );
//   }
// }
//
//
//
// class PushNotification {
//   PushNotification({
//     this.title,
//     this.body,
//   });
//
//   String title;
//   String body;
//
//   factory PushNotification.fromJson(Map<String, dynamic> json) {
//     return PushNotification(
//       title: json["notification"]["title"],
//       body: json["notification"]["body"],
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter/material.dart';
// //
// //
// // class MessageHandler extends StatefulWidget {
// //   @override
// //   _MessageHandlerState createState() => _MessageHandlerState();
// // }
// //
// // class _MessageHandlerState extends State<MessageHandler> {
// //   FirebaseMessaging _fcm;
// //
// //   @override
// //   void initState() {
// //
// //     // ...
// //
// //     _fcm.configure(
// //       onMessage: (Map<String, dynamic> message) async {
// //         print("onMessage: $message");
// //         showDialog(
// //           context: context,
// //           builder: (context) => AlertDialog(
// //             content: ListTile(
// //               title: Text(message['notification']['title']),
// //               subtitle: Text(message['notification']['body']),
// //             ),
// //             actions: <Widget>[
// //               FlatButton(
// //                 child: Text('Ok'),
// //                 onPressed: () => Navigator.of(context).pop(),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //       onLaunch: (Map<String, dynamic> message) async {
// //         print("onLaunch: $message");
// //         // TODO optional
// //       },
// //       onResume: (Map<String, dynamic> message) async {
// //         print("onResume: $message");
// //         // TODO optional
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // TODO: implement build
// //     throw UnimplementedError();
// //   }
// // // TODO...
// // } 