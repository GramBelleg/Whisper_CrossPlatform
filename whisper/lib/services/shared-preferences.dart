import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:whisper/components/user-state.dart';

Future<void> SaveEmail(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_email', email);
  print('Email saved: $email');
}

Future<String?> GetEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('user_email');
  print('Loaded email: $email');
  return email;
}

Future<void> SaveToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
  print('Token saved: $token');
}

Future<String?> GetToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
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
