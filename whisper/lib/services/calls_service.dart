import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/pages/login.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/services/show_loading_dialog.dart';
import 'package:whisper/socket.dart';

class CallsService {
  static Future<void> backGroundHandler(RemoteMessage message) async {
    print(message.notification!.body);
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 123,
          channelKey: "call_channel",
          color: Colors.white,
          title: message.notification?.title??"Empty",
          body: message.notification?.body??"Empty",
          category: NotificationCategory.Call,
          wakeUpScreen: true,
          fullScreenIntent: true,
          autoDismissible: false,
          backgroundColor: Colors.orange),
      actionButtons: [
        NotificationActionButton(
          key: "Accept",
          label: "Accept Call",
          color: Colors.green,
          autoDismissible: true,
        ),
        NotificationActionButton(
          key: "Reject",
          label: "Reject Call",
          color: Colors.red,
          autoDismissible: true,
        ),
      ],
    );
  }
  static Future<void> initializeAwesomeNotifications() async{
      await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: "call_channel",
            channelName: "Call Channel",
            channelDescription: "Channel of calling",
            defaultColor: Colors.red,
            ledColor: Colors.yellow,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            locked: true,
            defaultRingtoneType: DefaultRingtoneType.Ringtone),
      ],
    );
  }
  @pragma("vm:entry-point")
  static Future<void> onActionNotificationMethod(ReceivedAction action) async {
    if (action.buttonKeyPressed == 'Reject') {
      print("Call Rejected");
      await AwesomeNotifications().cancel(123);
    } else if (action.buttonKeyPressed == 'Accept') {
      print("Call Accepted");
    }
  }
  static Future<void> setListeners() async {
    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {
        print("AYHAGA");
        print(message.data['token']);
        String? title ="${message.notification!.title}+AYHAGA" ;
        String? body = message.notification!.body;
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 123,
              channelKey: "call_channel",
              color: Colors.white,
              title: title,
              body: body,
              category: NotificationCategory.Call,
              wakeUpScreen: true,
              fullScreenIntent: true,
              autoDismissible: false,
              backgroundColor: Colors.orange),
          actionButtons: [
            NotificationActionButton(
              key: "Accept",
              label: "Accept Call",
              color: Colors.green,
              autoDismissible: true,
            ),
            NotificationActionButton(
              key: "Reject",
              label: "Reject Call",
              color: Colors.red,
              autoDismissible: true,
            ),
          ],
        );
        AwesomeNotifications().setListeners(
          onActionReceivedMethod: onActionNotificationMethod,
        );
      },
    );
  }
  static Future<void> makeACall(BuildContext context,int id) async {
    final url = Uri.parse('http://$ip:5000/api/call/$id');
    final token = await getToken();
    print("BEFORE");
    showLoadingDialog(context);
    try{
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      var data = jsonDecode(response.body);
      print("INSIDE FCM TOKEN");
      print(data);
      Navigator.pop(context);
    }

    catch (e){
      print(e);
    }
  }
}
