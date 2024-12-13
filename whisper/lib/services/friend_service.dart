// services/friend_service.dart
import 'package:whisper/services/fetch_chats.dart';
import '../models/friend.dart';

class FriendService {
  Future<List<Friend>> fetchFriends() async {
    final chats = await fetchChats(); // Existing function
    return chats.map((chat) {
      return Friend(
        id: chat['id'],
        name: chat['name'] ?? 'User${chat['id']}',
        icon: chat['picture'] ?? 'assets/images/el-gayar.jpg',
        chatType: chat['type'],
      );
    }).toList();
  }
}
