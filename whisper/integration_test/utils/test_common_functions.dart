// this file contains common functions that are used in multiple tests
import 'dart:convert';
import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'auth_user.dart';

String generateLargeString(int length) {
  return 'a' * length;
}

Future<String?> getLastMessageId() async {
  final url = Uri.parse(
      'https://mailsac.com/api/addresses/${AuthUser.email_whisper_test}/messages?limit=1');
  final response = await http.get(
    url,
    headers: {
      'Mailsac-Key': AuthUser.api_key,
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

Future<String?> getMessageBody(String message_id) async {
  final url = Uri.parse(
      'https://mailsac.com/api/text/${AuthUser.email_whisper_test}/$message_id');
  final response = await http.get(
    url,
    headers: {
      'Mailsac-Key': AuthUser.api_key,
    },
  );

  if (response.statusCode == 200) {
    final String message = response.body;
    if (message.isNotEmpty) {
      return message;
    }
  } else {
    throw Exception('Failed to load message Body: ${response.statusCode}');
  }
  return null;
}

Future<String?> getVerificationCode() async {
  final message_id = await getLastMessageId();
  if (message_id != null) {
    final body_text = await getMessageBody(message_id);
    if (body_text != null) {
      String code;
      for (int i = 0; i < body_text.length; i++) {
        if (body_text[i] == 'c' &&
            body_text[i + 1] == 'o' &&
            body_text[i + 2] == 'd' &&
            body_text[i + 3] == 'e') {
          code = body_text.substring(i + 6, i + 14);
          return code;
        }
      }
    }
  }
  return null;
}
String generateRandomString(int length) {
  var random = Random.secure();
  var values = List<int>.generate(length, (i) => random.nextInt(255));
  return base64Url.encode(values);
}