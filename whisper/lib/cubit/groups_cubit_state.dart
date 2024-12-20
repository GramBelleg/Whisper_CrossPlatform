import 'package:equatable/equatable.dart';
import 'package:whisper/models/group_member.dart';

abstract class GroupsState {}

class GroupsInitial extends GroupsState {}

class UserAddedToGroup extends GroupsState {
  final GroupMember member;

  UserAddedToGroup(this.member);
}

class UserAddError extends GroupsState {
  final String error;

  UserAddError(this.error);
}

class UserRemovedFromGroup extends GroupsState {
  final GroupMember user;
  UserRemovedFromGroup(this.user);
}

class UserRemoveError extends GroupsState {
  final String errorMessage;
  UserRemoveError(this.errorMessage);
}

class AdminAdded extends GroupsState {
  final int userId;
  final int chatId;

  AdminAdded({required this.userId, required this.chatId});
}

class AdminAddError extends GroupsState {
  final String error;

  AdminAddError(this.error);
}
