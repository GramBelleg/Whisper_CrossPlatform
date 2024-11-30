import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/services/blocked_users_service.dart';

class BlockedUsersCubit extends Cubit<List<Map<String, dynamic>>> {
  final BlockedUsersService _blockedUsersService;
  BlockedUsersCubit(this._blockedUsersService) : super([]) {
    fetchBlockedUsers();
  }

  Future<void> fetchBlockedUsers() async {
    try {
      final blockedUsers = await _blockedUsersService.fetchBlockedUsers();
      emit(blockedUsers);
    } catch (e) {
      throw Exception("Failed to fetch blocked users: $e");
    }
  }

  Future<void> unblockUser(int index) async {
    try {
      final user = state[index];
      await _blockedUsersService.changeBlock(user['userId'], false);
      final blockedUsers = List<Map<String, dynamic>>.from(state);
      blockedUsers.removeAt(index);
      emit(blockedUsers);
    } catch (e) {
      throw Exception("Failed to unblock user at index $index with id ${state[index]['userId']} wtith exception as $e");
    }
  }
}
