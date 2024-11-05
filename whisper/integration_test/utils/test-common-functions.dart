// this file contains common functions that are used in multiple tests
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'auth-user.dart';
String generateLargeString(int length) {
  return 'a' * length;
}
String generateRandomString(int length) {
  var random = Random.secure();
  var values = List<int>.generate(length, (i) => random.nextInt(255));
  return base64Url.encode(values);
}

Future<String?> getLastMessageId() async {
  final url = Uri.parse('https://mailsac.com/api/addresses/${AuthUser.emailWhisperTest}/messages?limit=1');
  final response = await http.get(
    url,
    headers: {
      'Mailsac-Key': AuthUser.apiKey,
    },
  );

  if (response.statusCode == 200) {
    final List messages = jsonDecode(response.body);
    if (messages.isNotEmpty) {
      return messages[0]['_id'] as String;
    } else {
      return null;
    }
  } else {
    throw Exception('Failed to get Last Message ID: ${response.statusCode}');
  }
}

Future<String?> getMessageBody(String messageId) async {
  final url = Uri.parse('https://mailsac.com/api/text/${AuthUser.emailWhisperTest}/$messageId');
  final response = await http.get(
    url,
    headers: {
      'Mailsac-Key': AuthUser.apiKey,
    },
  );

  if (response.statusCode == 200) {
    final String message =response.body;
    if (message.isNotEmpty) {
      return message;
    }
  } else {
    throw Exception('Failed to load message Body: ${response.statusCode}');
  }
  return null;
}
Future<String?> getVerificationCode() async {
  final messageId = await getLastMessageId();
  if (messageId != null) {
    final bodyText = await getMessageBody(messageId);
    if (bodyText != null) {
      print(bodyText);
      String code;
      for(int i=0;i<bodyText.length;i++){
        if(bodyText[i]=='c' && bodyText[i+1]=='o' && bodyText[i+2]=='d' && bodyText[i+3]=='e'){
          code=bodyText.substring(i+6,i+14);
          return code;
        }
      }
    }
  }
  return null;
}
