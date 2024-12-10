import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whisper/models/user.dart';
import 'package:whisper/models/user_state.dart';

final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

Future<void> saveEmail(String email) async {
  await _secureStorage.write(key: 'user_email', value: email);
  print('Email saved: $email');
}

Future<void> saveRobotToken(String robotToken) async {
  await _secureStorage.write(key: 'robotToken', value: robotToken);
  print('robotToken saved: $robotToken');
}

Future<String?> getEmail() async {
  String? email = await _secureStorage.read(key: 'user_email');
  print('Loaded email: $email');
  return email;
}

Future<String?> getRobotToken() async {
  String? robotToken = await _secureStorage.read(key: 'robotToken');
  print('Loaded robotToken: $robotToken');
  return robotToken;
}

Future<void> saveToken(String token) async {
  print("new token :$token");
  await _secureStorage.write(key: 'token', value: token);
  print('Token saved: $token');
}

Future<String?> getToken() async {
  String? token = await _secureStorage.read(key: 'token');
  print('Loaded token: $token');
  return token;
}

Future<void> saveId(int id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('id', id);
  print('Id saved: $id');
}

Future<int?> getId() async {
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

  Map<String, dynamic> userStateMap = jsonDecode(userStateJson!);
  UserState userState = UserState.fromJson(userStateMap);
  print('Loaded UserState: $userState');
  return userState;
}

Future<void> saveUsers(List<User> users) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Convert the List<User> to a List<Map<String, dynamic>> of JSON
  List<Map<String, dynamic>> usersJson =
      users.map((user) => user.toJson()).toList();

  // Convert the List<Map<String, dynamic>> to a JSON string
  String usersJsonString = jsonEncode(usersJson);

  // Save the JSON string to SharedPreferences
  await prefs.setString('users', usersJsonString);
  print('Users saved: $usersJsonString');
}

Future<List<User>?> getUsers() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve the JSON string from SharedPreferences
  String? usersJsonString = prefs.getString('users');

  if (usersJsonString != null) {
    // Decode the JSON string to a List of Maps
    List<dynamic> usersJsonList = jsonDecode(usersJsonString);

    // Convert the List of Maps into a List<User>
    List<User> users =
        usersJsonList.map((userJson) => User.fromJson(userJson)).toList();

    print('Loaded Users: $users');
    return users;
  } else {
    print('No users found');
    return null;
  }
}

Future<void> saveMyUser(User user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Convert the User object to JSON
  Map<String, dynamic> userJson = user.toJson();

  // Convert the Map<String, dynamic> to a JSON string
  String userJsonString = jsonEncode(userJson);

  // Save the JSON string to SharedPreferences
  await prefs.setString('user', userJsonString);
  print('User saved: $userJsonString');
}

Future<User?> getMyUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Retrieve the JSON string from SharedPreferences
  String? userJsonString = prefs.getString('user');

  if (userJsonString != null) {
    // Decode the JSON string to a Map
    Map<String, dynamic> userJson = jsonDecode(userJsonString);

    // Convert the Map into a User object
    User user = User.fromJson(userJson);

    print('Loaded User: $user');
    return user;
  } else {
    print('No user found');
    return null;
  }
}
