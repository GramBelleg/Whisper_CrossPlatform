import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

Future<void> SaveSignupCredentials(SignupCredentials credentials) async {
  await _secureStorage.write(key: 'email', value: credentials.email!);
  await _secureStorage.write(key: 'name', value: credentials.name!);
  await _secureStorage.write(key: 'userName', value: credentials.userName!);
  await _secureStorage.write(key: 'password', value: credentials.password!);
  await _secureStorage.write(
      key: 'confirmPassword', value: credentials.confirmPassword!);
  await _secureStorage.write(
      key: 'phoneNumber', value: credentials.phoneNumber!);

  print('Signup credentials saved securely: $credentials');
}

Future<SignupCredentials> GetSignUpCredentials() async {
  SignupCredentials credential = SignupCredentials();

  credential.email = await _secureStorage.read(key: 'email');
  credential.password = await _secureStorage.read(key: 'password');
  credential.confirmPassword =
      await _secureStorage.read(key: 'confirmPassword');
  credential.phoneNumber = await _secureStorage.read(key: 'phoneNumber');
  credential.userName = await _secureStorage.read(key: 'userName');
  credential.name = await _secureStorage.read(key: 'name');

  print(
      'Signup credentials retrieved securely: ${credential.email}, ${credential.phoneNumber}');
  return credential;
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
