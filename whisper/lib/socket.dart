import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:whisper/global-cubit-provider.dart';
import 'package:whisper/services/read-file.dart';
import 'package:whisper/services/shared-preferences.dart';

class SocketService {
  // Private constructor
  SocketService._internal();

  // Singleton instance
  static final SocketService _instance = SocketService._internal();

  // Socket instance
  IO.Socket? socket;

  static SocketService get instance => _instance;

  // Initialize and connect the socket

  Future<void> connectSocket() async {
    _clearExistingListeners();
    String? token = await GetToken();
    _initializeSocket(token);
    print(socket);
    GlobalCubitProvider.messagesCubit.setupSocketListeners();
  }

  void _initializeSocket(String? token) {
    socket = IO.io("http://192.168.2.100:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      'query': {'token': "Bearer $token"}
    });
    socket?.connect();
  }

  void _clearExistingListeners() {
    socket?.disconnect(); //da lesa maktob we matgarab4
    socket?.clearListeners();
  }

  void dispose() {
    socket?.disconnect();
    socket = null;
  }
}

// socket?.on('pfp', (data) async {
//   print("changed Profile Pic: $data");
//   final UserState? userState = await getUserState();
//   print("this is userid from socket: ${data['userId']} ");
//   if (data['userId'] == await GetId()) {
//     String response = await generatePresignedUrl(data['profilePic']);
//     userState?.copyWith(profilePic: response);
//   }
// });
