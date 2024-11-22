import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:whisper/cubit/messages-cubit.dart';
import 'package:whisper/modules/login-credentials.dart';
import 'package:whisper/pages/mainchats-page.dart';
import 'package:whisper/services/shared-preferences.dart';

Future<void> login(LoginCredentials loginCred, BuildContext context) async {
  final url = Uri.parse('http://localhost:5000/api/auth/login');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(loginCred.toMap()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var data = jsonDecode(response.body);
      await SaveToken(data['userToken']);

      print('Response: $data');
      await SaveEmail(loginCred.email!);
      await SaveId(data['user']['id']);
      ////////
      var token =
          await GetToken(); // Make sure GetToken is awaited to fetch the token
      print("dammmmmmmmmn$token");
      // Pass the token to connectSocket
      context.read<MessagesCubit>().connectSocket(token!);
      Navigator.pushNamed(context, MainChats.id);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: ${response.statusCode}"),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Something went wrong: ${e}"),
      ),
    );
  }
}
