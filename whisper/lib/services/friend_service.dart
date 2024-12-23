// services/friend_service.dart
import 'package:whisper/models/chat.dart';
import 'package:whisper/services/fetch_addable_friends.dart';
import 'package:whisper/services/chats_services/fetch_chats.dart';
import '../models/friend.dart';

class FriendService {
  Future<List<Chat>> fetchFriends() async {
    final chats = await fetchChats(); // Existing function
    return chats
        .where((chat) => chat['type'] != 'CHANNEL') // Exclude channels
        .map((chat) {
      return Chat(
        othersId: chat['id'],
        userName: chat['name'] ?? 'User${chat['id']}',
        avatarUrl: chat['picture'] ?? 'assets/images/el-gayar.jpg',
        type: chat['type'],
        chatId: chat['id'],
      );
    }).toList();
  }

  Future<List<Chat>> fetchMembers(int groupId) async {
    final chats = await fetchAddableUsers(groupId); // Existing function
    return chats.map((chat) {
      return Chat(
        othersId: chat['id'],
        userName: chat['userName'] ?? 'User${chat['id']}',
        avatarUrl: chat['profilePic'],
        type: "DM",
      );
    }).toList();
  }
}
