import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/services/group_management_service.dart';

class GroupUserPermissionsCubit extends Cubit<Map<String, bool>> {
  final GroupManagementService _groupManagementService;

  GroupUserPermissionsCubit(this._groupManagementService) : super({}) {
    //   _permissions = {
    //   "canPost": true,
    //   "canEdit": true,
    //   "canDelete": true,
    //   "canDownload": true
    // };
  }

  Future<bool> loadUserPermissions(int chatId, int userId) async {
    try {
      final permissions =
          await _groupManagementService.getUserPermissions(chatId, userId);
      emit(permissions);
      return true;
    } catch (e) {
      print("FAILED TO LOAD USER PERMISSIONS: $e");
      return false;
    }
  }

  Future<void> updateUserPermissions(
      int chatId, int userId, Map<String, bool> permissions) async {
    try {
      await _groupManagementService.setUserPermissions(
          chatId, userId, permissions);

      // this second  get request may be unnecessary, 
      // I can check for the return status of the first request

      final updatedPermissions =
          await _groupManagementService.getUserPermissions(chatId, userId);
      emit(updatedPermissions);
    } catch (e) {
      print("FAILED TO UPDATE USER PERMISSIONS: $e");
    }
  }

  Future<void> updatePermissions(
      int chatId, int userId, String permission, bool value) async {
    final permissions = Map<String, bool>.from(state);
    permissions[permission] = value;
    await updateUserPermissions(chatId, userId, permissions);
  }
}
