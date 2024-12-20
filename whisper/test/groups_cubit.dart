// Mocks generated by Mockito from annotations
// Do not manually edit this file.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:whisper/cubit/groups_cubit.dart';
import 'package:whisper/cubit/groups_cubit_state.dart';
import 'package:whisper/models/group_member.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'groups_cubit.mocks.dart';

@GenerateNiceMocks([MockSpec<IO.Socket>()])
void main() {
  late MockSocket mockSocket;
  late GroupsCubit groupsCubit;

  setUp(() {
    mockSocket = MockSocket();
    groupsCubit = GroupsCubit();
    groupsCubit.socket = mockSocket;
  });

  tearDown(() {
    groupsCubit.close();
  });

  group('GroupsCubit Tests', () {
    test('Initial state is GroupsInitial', () {
      expect(groupsCubit.state, isA<GroupsInitial>());
    });

    test('addUserToGroup emits UserAddedToGroup on success', () async {
      final groupId = 1;
      final userId = 123;
      final userName = 'Test User';
      final profilePic = 'test_pic.png';

      when(mockSocket.emit(any, any)).thenAnswer((_) {});

      groupsCubit.addUserToGroup(
        groupId: groupId,
        userId: userId,
        userName: userName,
        profilePic: profilePic,
      );

      verify(mockSocket.emit('addUser', {
        'user': {
          'id': userId,
          'userName': userName,
          'profilePic': profilePic,
        },
        'chatId': groupId,
      })).called(1);
    });

    test('addUserToGroup emits UserAddError on failure', () async {
      final groupId = 1;
      final userId = 123;
      final userName = 'Test User';
      final profilePic = 'test_pic.png';

      when(mockSocket.emit(any, any)).thenAnswer((_) {});

      groupsCubit.addUserToGroup(
        groupId: groupId,
        userId: userId,
        userName: userName,
        profilePic: profilePic,
      );

      await expectLater(
        groupsCubit.stream,
        emitsInOrder([isA<UserAddError>()]),
      );
    });

    test('removeUserFromGroup emits UserRemovedFromGroup on success', () async {
      final groupId = 1;
      final user = GroupMember(
        id: 123,
        userName: 'Test User',
        profilePic: null,
        isAdmin: false,
        hasStory: false,
        lastSeen: DateTime.now(),
      );

      when(mockSocket.emit(any, any)).thenAnswer((_) {});

      groupsCubit.removeUserFromGroup(
        groupId: groupId,
        user: user,
      );

      verify(mockSocket.emit('removeUser', {
        'user': {
          'id': user.id,
          'userName': user.userName,
        },
        'chatId': groupId,
      })).called(1);
    });

    test('removeUserFromGroup emits UserRemoveError on failure', () async {
      final groupId = 1;
      final user = GroupMember(
        id: 123,
        userName: 'Test User',
        profilePic: null,
        isAdmin: false,
        hasStory: false,
        lastSeen: DateTime.now(),
      );

      when(mockSocket.emit(any, any)).thenThrow(Exception('Socket Error'));

      groupsCubit.removeUserFromGroup(
        groupId: groupId,
        user: user,
      );

      await expectLater(
        groupsCubit.stream,
        emitsInOrder([isA<UserRemoveError>()]),
      );
    });

    test('addAdminToGroup emits AdminAdded on success', () async {
      final groupId = 1;
      final userId = 123;

      when(mockSocket.emit(any, any)).thenAnswer((_) {});

      groupsCubit.addAdminToGroup(
        groupId: groupId,
        userId: userId,
      );

      verify(mockSocket.emit('addAdmin', {
        'userId': userId,
        'chatId': groupId,
      })).called(1);
    });

    test('addAdminToGroup emits AdminAddError on failure', () async {
      final groupId = 1;
      final userId = 123;

      when(mockSocket.emit(any, any)).thenThrow(Exception('Socket Error'));

      groupsCubit.addAdminToGroup(
        groupId: groupId,
        userId: userId,
      );

      await expectLater(
        groupsCubit.stream,
        emitsInOrder([isA<AdminAddError>()]),
      );
    });

    test('Socket listener for addUser emits UserAddedToGroup', () async {
      final userData = {
        'user': {
          'id': 123,
          'userName': 'Test User',
          'profilePic': 'test_pic.png',
        },
        'lastSeen': DateTime.now().toString(),
      };

      when(mockSocket.on(any, any)).thenAnswer((invocation) {
        final event = invocation.positionalArguments[0];
        final Function callback = invocation.positionalArguments[1] as Function;

        if (event == 'addUser') {
          callback(userData);
        }
        return () {};
      });

      groupsCubit.setupSocketListeners();
      groupsCubit.socket?.on(
          'addUser',
          (data) => groupsCubit.emit(UserAddedToGroup(GroupMember(
                id: data['user']['id'],
                userName: data['user']['userName'],
                profilePic: data['user']['profilePic'],
                isAdmin: false,
                hasStory: false,
                lastSeen: DateTime.now(),
              ))));

      expect(groupsCubit.state, isA<UserAddedToGroup>());
    });

    test('Socket listener for removeUser emits UserRemovedFromGroup', () async {
      final userData = {
        'user': {
          'id': 123,
          'userName': 'Test User',
          'profilePic': null,
        },
        'lastSeen': DateTime.now().toString(),
      };

      when(mockSocket.on(any, any)).thenAnswer((invocation) {
        final event = invocation.positionalArguments[0];
        final Function callback = invocation.positionalArguments[1] as Function;

        if (event == 'removeUser') {
          callback(userData);
        }
        return () {};
      });

      groupsCubit.setupSocketListeners();
      groupsCubit.socket?.on(
          'removeUser',
          (data) => groupsCubit.emit(UserRemovedFromGroup(GroupMember(
                id: data['user']['id'],
                userName: data['user']['userName'],
                profilePic: data['user']['profilePic'],
                isAdmin: false,
                hasStory: false,
                lastSeen: DateTime.now(),
              ))));

      expect(groupsCubit.state, isA<UserRemovedFromGroup>());
    });

    test('Socket listener for addAdmin emits AdminAdded', () async {
      final adminData = {
        'userId': 123,
        'chatId': 1,
      };

      when(mockSocket.on(any, any)).thenAnswer((invocation) {
        final event = invocation.positionalArguments[0];
        final Function callback = invocation.positionalArguments[1] as Function;

        if (event == 'addAdmin') {
          callback(adminData);
        }
        return () {};
      });

      groupsCubit.setupSocketListeners();
      groupsCubit.socket?.on(
          'addAdmin',
          (data) => groupsCubit.emit(
              AdminAdded(userId: data['userId'], chatId: data['chatId'])));

      expect(groupsCubit.state, isA<AdminAdded>());
    });
  });
}
