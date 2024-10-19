import 'package:shared_preferences/shared_preferences.dart';

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
  print('Loaded email: $token');
  return token;
}
