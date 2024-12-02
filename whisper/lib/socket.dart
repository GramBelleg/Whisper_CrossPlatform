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

  // Getter to access the instance
  static SocketService get instance => _instance;

  // Initialize and connect the socket
  Future<void> initSocket() async {
    _clearExistingListeners();
    String? token = await GetToken();
    _initializeSocket(token!);

    socket?.connect();
    socket?.onConnect((_) => print('Connected to socket server'));
  }

  void _initializeSocket(String token) {
    socket = IO.io("http://$ip:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      'query': {'token': "Bearer $token"}
    });
  }

  void _setupSocketListeners() {
    socket?.on('pfp', (data) async {
      print("changed Profile Pic: $data");
      final UserState? userState = await getUserState();
      print("this is userid from socket: ${data['userId']} ");
      if (data['userId'] == await GetId()) {
        String response = await generatePresignedUrl(data['profilePic']);
        userState?.copyWith(profilePic: response);
      }
    });

    socket?.onConnectError((error) {
      print("Error in connect");
    });

    socket?.onDisconnect((_) => print('Disconnected from socket server'));
    socket?.on('message', (data) {});

    socket?.on('error', (err) {
      print(err);
    });
  }

  void sendStory(String blobName, String content, String type) {
    print("send my story");
    socket
        ?.emit('story', {"content": content, "media": blobName, "type": type});
  }

  void deleteStory(int storyId) {
    print("send storyyy");
    socket?.emit('deleteStory', {"storyId": storyId});
  }

  void _clearExistingListeners() {
    socket?.clearListeners();
  }

  // Ensure that the socket is initialized before you try to use it
  IO.Socket? getSocket() {
    if (socket == null || !socket!.connected) {
      return null;
    }
    return socket;
  }

  // Disconnect the socket
  void dispose() {
    socket?.disconnect();
    socket = null;
  }
}
