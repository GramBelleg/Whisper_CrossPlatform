import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whisper/models/chat_message.dart';
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

  if (userStateJson == null) {
    print('No UserState found');
    return null;
  }

  Map<String, dynamic> userStateMap = jsonDecode(userStateJson);
  UserState userState = UserState.fromJson(userStateMap);
  print('Loaded UserState: $userState');
  return userState;
}

Future<void> cacheMessages(int chatId, List<ChatMessage> messages) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> cachedMessages =
      messages.map((message) => jsonEncode(message.toJson())).toList();
  await prefs.setStringList('cached_messages_$chatId', cachedMessages);
  print('Messages for chatId $chatId cached');
}

Future<void> cacheSingleMessage(int chatId, ChatMessage message) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String cachedMessage = jsonEncode(message.toJson());
  await prefs.setString('cached_message_$chatId', cachedMessage);
  print('Single message for chatId $chatId cached');
}

Future<List<ChatMessage>> loadCachedMessages(int chatId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? cachedMessages = prefs.getStringList('cached_messages_$chatId');
  if (cachedMessages != null) {
    return cachedMessages
        .map((messageJson) => ChatMessage.fromJson(jsonDecode(messageJson)))
        .toList();
  }
  return [];
}

Future<void> removeCachedMessagesByIds(int chatId, List<int> messageIds) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? cachedMessages = prefs.getStringList('cached_messages_$chatId');

  if (cachedMessages != null) {
    List<String> filteredMessages = cachedMessages.where((messageJson) {
      ChatMessage message = ChatMessage.fromJson(jsonDecode(messageJson));
      return !messageIds.contains(message.id);
    }).toList();
    await prefs.setStringList('cached_messages_$chatId', filteredMessages);
    print(
        'Messages with IDs ${messageIds.join(', ')} removed for chatId $chatId');
  }
}

Future<void> editCachedMessageContentById(
    int chatId, int id, String newContent) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? cachedMessages = prefs.getStringList('cached_messages_$chatId');
  if (cachedMessages != null) {
    try {
      String messageJson = cachedMessages.firstWhere((messageJson) {
        ChatMessage message = ChatMessage.fromJson(jsonDecode(messageJson));
        return message.id == id;
      });
      ChatMessage message = ChatMessage.fromJson(jsonDecode(messageJson));
      message.content = newContent;
      cachedMessages[cachedMessages.indexOf(messageJson)] =
          jsonEncode(message.toJson());
      await prefs.setStringList('cached_messages_$chatId', cachedMessages);
      print('Message content updated for message ID $id in chatId $chatId');
    } catch (e) {
      print('Message with ID $id not found.');
    }
  }
}

Future<void> saveImageUrl(String blobName, String imageUrl) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('image_url_$blobName', imageUrl);
  print('Image URL saved for blob name $blobName: $imageUrl');
}

Future<String?> getImageUrl(String blobName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? imageUrl = prefs.getString('image_url_$blobName');
  if (imageUrl != null) {
    print('Loaded image URL for blob name $blobName: $imageUrl');
    return imageUrl;
  }
  return null;
}



// Future<void> saveUser(User user) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String userJson = jsonEncode(user.toJson());
//   await prefs.setString('user', userJson);
//   print('User saved: $userJson');
// }

// Future<User?> getUser() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? userJson = prefs.getString('user');

//   if (userJson == null) {
//     print('No User found');
//     return null;
//   }

//   Map<String, dynamic> userMap = jsonDecode(userJson);
//   User user = User.fromJson(userMap);
//   print('Loaded User: $user');
//   return user;
// }
