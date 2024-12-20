// services/friend_service.dart
import 'package:whisper/services/fetch_addable_friends.dart';
import 'package:whisper/services/fetch_chats.dart';
import '../models/friend.dart';

class FriendService {
  Future<List<Friend>> fetchFriends() async {
    final chats = await fetchChats();

    return chats.where((chat) {
      return chat['type'] != 'CHANNEL' ||
          (chat['isAdmin'] == true && chat['type'] == 'CHANNEL');
    }).map((chat) {
      return Friend(
        id: chat['id'],
        name: chat['name'] ?? 'User${chat['id']}',
        icon: chat['picture'] ?? 'assets/images/el-gayar.jpg',
        chatType: chat['type'],
        isAdmin: chat['isAdmin'] ?? false,
      );
    }).toList();
  }

  Future<List<Friend>> fetchMembers(int groupId) async {
    final chats = await fetchAddableUsers(groupId); // Existing function
    return chats.map((chat) {
      return Friend(
        id: chat['id'],
        name: chat['userName'] ?? 'User${chat['id']}',
        icon: chat['profilePic'],
        chatType: "DM",
        isAdmin: false,
      );
    }).toList();
  }
}
