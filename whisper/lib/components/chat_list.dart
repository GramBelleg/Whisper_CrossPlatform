import 'package:intl/intl.dart';
import 'package:whisper/models/chat.dart';
import '../services/fetch_chats.dart';

class ChatList {
  List<Chat> _chats = [];

  Future<void> initializeChats() async {
    try {
      List<dynamic> retrievedChats = await fetchChats();
      if (retrievedChats.isNotEmpty) {
        print("fetch chats");
        _chats =
            retrievedChats.map((chatJson) => _JSONIntoChat(chatJson)).toList();
        _chats.forEach((chat) => print(
            "Chat: ${chat.userName}, Last Message: ${chat.lastMessage.content}"));
      } else {
        _chats = [];
      }
    } catch (error) {
      print('Failed to fetch chats: $error');
      _chats = [];
    }
  }

  List<Chat> get chats {
    return _sortChatsByTime(_chats);
  }

  List<Chat> _sortChatsByTime(List<Chat> chats) {
    // Sort the chats based on the `time` field of the last message in descending order
    chats.sort((a, b) {
      DateTime aTime = DateTime.parse(a.time); // Parse time string to DateTime
      DateTime bTime = DateTime.parse(b.time);
      return bTime
          .compareTo(aTime); // Sort in descending order (most recent first)
    });
    return chats;
  }

  void addChat(Map<String, dynamic> chatJson) {
    Chat chat = _JSONIntoChat(chatJson);
    _chats.add(chat);
  }

  void deleteChat(Chat chat) {
    _chats.remove(chat);
  }

  void muteChat(Chat chat) {
    chat.copyWith(isMuted: true);
  }

  void unmuteChat(Chat chat) {
    chat.copyWith(isMuted: false);
  }

  // Helper method to convert the raw JSON into a Chat object
  Chat _JSONIntoChat(Map<String, dynamic> chatJson) {
    bool isOnline = chatJson['lastSeen'] != null &&
        DateTime.now()
                .difference(DateTime.parse(chatJson['lastSeen']))
                .inMinutes <
            5;

    return Chat.fromJson(chatJson, isOnline); // Use Chat.fromJson constructor
  }
}
