import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:whisper/components/user-state.dart';
import 'package:whisper/constants/ip-for-services.dart';
import 'package:whisper/services/read-file.dart';
import 'package:whisper/services/shared-preferences.dart';

class SocketService {
  // Private constructor
  SocketService._internal();

  // Singleton instance
  static final SocketService _instance = SocketService._internal();

  // Socket instance
  IO.Socket? socket;

  // Define separate StreamControllers for different events
  // final StreamController<dynamic> _messageStreamController =
  //     StreamController.broadcast();
  // final StreamController<dynamic> _profilePicStreamController =
  //     StreamController.broadcast();

  // // Stream<dynamic> get messageStream => _messageStreamController.stream;
  // Stream<dynamic> get profilePicStream => _profilePicStreamController.stream;
  // Stream<dynamic> get statusStream => _profilePicStreamController.stream;

  // Getter to access the instance
  static SocketService get instance => _instance;

  // Initialize and connect the socket
  Future<void> initSocket() async {
    String? token = await GetToken();
    socket = IO.io("http://$ip:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      'query': {'token': "Bearer ${token as String}"}
    });

    // Connect to the socket server
    socket?.connect();

    // Listen for messages directly and handle them
    // socket?.on('receiveMessage', (data) {
    //   _messageStreamController.add(data); // Handle incoming messages directly
    // });

    socket?.on('pfp', (data) async {
      print("changed Profile Pic: $data");
      final UserState? userState = await getUserState();
      print("this is userid from socket: ${data['userId']} ");
      if (data['userId'] == await GetId()) {
        String response = await generatePresignedUrl(data['profilePic']);
        userState?.copyWith(profilePic: response);
      }
    });

    // Optional: Listen for connection events
    socket?.onConnect((_) => print('Connected to socket server'));
    socket?.onDisconnect((_) => print('Disconnected from socket server'));
  }

  // Disconnect the socket
  void dispose() {
    //_messageStreamController.close();
    // _profilePicStreamController.close();
    socket?.disconnect();
    socket = null;
  }
}
