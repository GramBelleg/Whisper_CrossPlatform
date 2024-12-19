import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/pages/call_page.dart';
import 'package:whisper/pages/login.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/services/show_loading_dialog.dart';
import 'package:whisper/socket.dart';

import '../main.dart';

class CallsService {
  static Future<void> backGroundHandler(RemoteMessage message) async {
    print(message.notification!.body);
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 123,
          channelKey: "call_channel",
          color: Colors.white,
          title: message.notification?.title ?? "Empty",
          body: message.notification?.body ?? "Empty",
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
    if (message.data['action'] == 'accept') {
      navigatorKey.currentState!.push(
        MaterialPageRoute(
            builder: (context) => Call(),
            settings: RouteSettings(arguments: {
              'token': message.data['action'].payload!['token'],
              'chatId': message.data['action'].payload!['channelName'],
            },)
        ),
      );
    }
  }

  static Future<void> initializeAwesomeNotifications() async {
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
    print("payload : ${action.payload}");
    if (action.buttonKeyPressed == 'Reject') {
      print("Call Rejected");
      await AwesomeNotifications().cancel(123);
    } else if (action.buttonKeyPressed == 'Accept') {
      print("Call Accepted");
      print(action.payload!['token']);
      print(action.payload!['channelName']!);
      RegExp regex = RegExp(r'-(\d+)');
      Match? match = regex.firstMatch(action.payload!['channelName']!);
      int chatId = int.parse(match!.group(1)!);
      print("CHAT IDDDD : ${chatId}");
      await CallsService.joinCall(chatId);
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => Call(),
          settings: RouteSettings(arguments: {
            'token': action.payload!['token'],
            'chatId': action.payload!['channelName'],
          },)
        ),
      );

    }
  }

  static Future<void> leaveCall(int? chatId,String? endStatus, BuildContext context) async {
    final url = Uri.parse('http://$ip:5000/api/call/leave/$chatId');
    final token = await getToken();
    print("BEFORE");
    try{
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'endStatus':endStatus
        })
      );
      var data = jsonDecode(response.body);
      print(data);
    }
    catch (e){
      print(e);
    }
  }
  static Future<void> joinCall(int? chatId) async {
    final url = Uri.parse('http://$ip:5000/api/call/join/$chatId');
    final token = await getToken();
    print("BEFORE");

    try{
      final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
      );
      var data = jsonDecode(response.body);
      print(data);
    }
    catch (e){
      print(e);
    }
  }
  static Future<void> setListeners() async {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print("AYHAGA");
        print(message.data);
        String? title = "${message.notification!.title}+AYHAGA";
        String? body = message.notification!.body;
        String? chatId=message.data['channelName'];
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
            backgroundColor: Colors.orange,
            payload: {
              "token": message.data['token'] ?? "unknown",
              "channelName": message.data['channelName'] ?? "default",
            },
          ),
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

  static Future<String> makeACall(BuildContext context, int id) async {
    final url = Uri.parse('http://$ip:5000/api/call/$id');
    final token = await getToken();
    print("BEFORE");
    showLoadingDialog(context);
    try {
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
      if (data['status'] == 'success')
        return data['token'];
      else
        return 'error';
    } catch (e) {
      print(e);
      return 'error';
    }
  }
}
