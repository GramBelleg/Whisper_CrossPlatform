import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/services/group_management_service.dart';

abstract class GroupUserPermissionsState {}

class PermissionsLoading extends GroupUserPermissionsState {}

class PermissionsLoaded extends GroupUserPermissionsState {
  final Map<String, bool> permissions;
  PermissionsLoaded(this.permissions);
}

class PermissionsError extends GroupUserPermissionsState {
  final String errorMessage;
  PermissionsError(this.errorMessage);
}

class GroupUserPermissionsCubit extends Cubit<GroupUserPermissionsState> {
  final GroupManagementService _groupManagementService;

  GroupUserPermissionsCubit(this._groupManagementService)
      : super(PermissionsLoading());

  Future<void> loadUserPermissions(int chatId, int userId) async {
    emit(PermissionsLoading());
    try {
      final permissions =
          await _groupManagementService.getUserPermissions(chatId, userId);
      emit(PermissionsLoaded(permissions));
    } catch (e) {
      emit(PermissionsError('Failed to load permissions: $e'));
    }
  }

  Future<void> updatePermission(
      int chatId, int userId, String permissionKey, bool newValue) async {
    if (state is PermissionsLoaded) {
      final currentPermissions = Map<String, bool>.from(
          (state as PermissionsLoaded).permissions);
      currentPermissions[permissionKey] = newValue;

      emit(PermissionsLoaded(currentPermissions));

      try {
        final isSuccess = await _groupManagementService.setUserPermissions(
          chatId,
          userId,
          currentPermissions,
        );
        if (!isSuccess) {
          throw Exception("Failed to update permission.");
        }
      } catch (e) {
        emit(PermissionsError('Failed to update permission: $e'));
        // Revert the optimistic update
        currentPermissions[permissionKey] = !newValue;
        emit(PermissionsLoaded(currentPermissions));
      }
    }
  }
}
