import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whisper/components/user-state.dart';
import 'package:whisper/modules/signup-credentials.dart';

final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

Future<void> SaveEmail(String email) async {
  await _secureStorage.write(key: 'user_email', value: email);
  print('Email saved: $email');
}

Future<void> SaveRobotToken(String robotToken) async {
  await _secureStorage.write(key: 'robotToken', value: robotToken);
  print('robotToken saved: $robotToken');
}

Future<String?> GetEmail() async {
  String? email = await _secureStorage.read(key: 'user_email');
  print('Loaded email: $email');
  return email;
}

Future<String?> GetRobotToken() async {
  String? robotToken = await _secureStorage.read(key: 'robotToken');
  print('Loaded robotToken: $robotToken');
  return robotToken;
}

Future<void> SaveToken(String token) async {
  await _secureStorage.write(key: 'token', value: token);
  print('Token saved: $token');
}

Future<String?> GetToken() async {
  String? token = await _secureStorage.read(key: 'token');
  print('Loaded token: $token');
  return token;
}

Future<void> SaveId(int id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('id', id);
  print('Id saved: $id');
}

Future<int?> GetId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('id');
  print('Loaded Id: $id');
  return id;
}

Future<void> saveUserState(UserState userState) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userStateJson = jsonEncode(userState.toJson());
  await prefs.setString('user_state', userStateJson);
  print('UserState saved: $userStateJson');
}

Future<UserState?> getUserState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userStateJson = prefs.getString('user_state');

  if (userStateJson == null) {
    print('No UserState found');
    return null;
  }

  Map<String, dynamic> userStateMap = jsonDecode(userStateJson);
  UserState userState = UserState.fromJson(userStateMap);
  print('Loaded UserState: $userState');
  return userState;
}
