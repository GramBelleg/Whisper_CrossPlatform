import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:whisper/constants/ip_for_services.dart';
import 'package:whisper/global_cubits/global_cubit_provider.dart';
import 'package:whisper/global_cubits/global_groups_provider.dart';
import 'package:whisper/global_cubits/global_setting_cubit.dart';
import 'package:whisper/global_cubits/global_user_story_cubit_provider.dart';
import 'package:whisper/services/shared_preferences.dart';

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
    String? token = await getToken();
    print("in socket token : $token");
    _initializeSocket(token);
    GlobalCubitProvider.messagesCubit.setupSocketListeners();
    GlobalGroupsProvider.groupsCubit.setupSocketListeners();
    GlobalUserStoryCubitProvider.userStoryCubit.setupSocketListeners();

    socket?.on('pfp', (data) async {
      print("changed Profile Pic: $data");
      print("this is userid from socket: ${data['userId']} ");
      if (data['userId'] == await getId()) {
        GlobalSettingsCubitProvider.settingsCubit
            .receiveMyProfilePic(data['profilePic']);
      } else {
        // to do receive another pfp
      }
    });
  }

  void _initializeSocket(String? token) {
    socket = IO.io("http://$ip:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      'query': {'token': "Bearer $token"}
    });
    socket?.connect();
  }

  void _clearExistingListeners() {
    socket?.clearListeners();
  }

  void dispose() {
    socket?.disconnect();
    socket = null;
  }

  void sendStory(String content, String blobName, String type) {
    print("send  story");
    socket
        ?.emit('story', {"content": content, "media": blobName, "type": type});
  }

  void deleteStory(int storyId) {
    print("delete storyyy");
    socket?.emit('deleteStory', {"storyId": storyId});
  }
}
