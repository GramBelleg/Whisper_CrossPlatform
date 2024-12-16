import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/cubit/groups_cubit_state.dart';
import 'package:whisper/models/friend.dart';
import 'package:whisper/models/group_member.dart';
import 'package:whisper/models/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:whisper/socket.dart';

class GroupsCubit extends Cubit<GroupsState> {
  final socket = SocketService.instance.socket;

  GroupsCubit() : super(GroupsInitial());

  void setupSocketListeners() {
    socket?.on('addUser', (data) {
      _handleUserAdded(data);
    });
    socket?.on('removeUser', (data) {
      print("remove user");
      _handleUserRemoved(data);
    });
  }

  void addUserToGroup({
    required int groupId,
    required int userId,
    required String userName,
    String? profilePic,
  }) {
    final userData = {
      'user': {
        'id': userId,
        'userName': userName,
        'profilePic': profilePic,
      },
      'chatId': groupId,
    };
    print("aaaaaaaaaaaaaaaaddddddffff");
    try {
      socket?.emit('addUser', userData);
    } catch (e) {
      emit(UserAddError(e.toString()));
    }
  }

  void removeUserFromGroup({
    required int groupId,
    required GroupMember user,
  }) {
    final userData = {
      'user': {
        'id': user.id,
        'userName': user.userName,
      },
      'chatId': groupId,
    };

    try {
      socket?.emit('removeUser', userData);
    } catch (e) {
      emit(UserRemoveError(e.toString()));
    }
  }

  void _handleUserAdded(Map<String, dynamic> data) {
    try {
      print("4444444444$data");
      final user = GroupMember(
        id: data['user']['id'] as int,
        userName: data['user']['userName'] as String,
        profilePic: data['user']['profilePic'],
        isAdmin: false,
        hasStory: false,
        lastSeen: DateTime.now(),
      );
      emit(UserAddedToGroup(user));
    } catch (e) {
      emit(UserAddError('Error processing user added data: ${e.toString()}'));
    }
  }

  void _handleUserRemoved(Map<String, dynamic> data) {
    try {
      print("aaaaaaaaaaaaaddddddddddd$data");
      final user = GroupMember(
        id: data['user']['id'] as int,
        userName: data['user']['userName'] as String,
        profilePic: null,
        isAdmin: false,
        hasStory: false,
        lastSeen: DateTime.now(),
      );
      print("aaaaaaaaaaaaaddddddddddd${user.toString()}");
      emit(UserRemovedFromGroup(user));
    } catch (e) {
      emit(UserRemoveError(
          'Error processing user removal data: ${e.toString()}'));
    }
  }
}
