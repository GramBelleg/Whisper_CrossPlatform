import 'package:intl/intl.dart'; // Import for date formatting
import '../services/chats-services.dart';
import 'chat-card.dart'; // Assuming this imports MessageType and other relevant definitions

class ChatList {
  List<Map<String, dynamic>> _chatData = [];

  Map<String, dynamic> _applyDefaults(Map<String, dynamic> chat) {
    // Parse the createdAt time if it exists
    DateTime messageTime = chat['lastMessage']?['sentAt'] != null
        ? DateTime.parse(chat['lastMessage']['sentAt'])
            .toLocal() // Convert UTC to local time
        : DateTime.now();

    // Calculate the difference from now
    Duration difference = DateTime.now().difference(messageTime);

    // Format the time according to criteria
    String formattedTime;
    if (difference.inDays == 0) {
      formattedTime = DateFormat.jm().format(messageTime); // e.g., 3:30 PM
    } else if (difference.inDays < 7) {
      formattedTime = DateFormat.E().format(messageTime); // e.g., Mon
    } else {
      formattedTime = DateFormat.Md().format(messageTime); // e.g., 10/9
    }

    return {
      'chatid': chat['id'],
      'userName': chat['name'] ?? 'User ${chat['id']}',
      'lastMessage': chat['lastMessage']?['content'] ?? '',
      'time': formattedTime,
      'avatarUrl': chat['other']?['profilePic'] ?? 'assets/images/el-gayar.jpg',
      'isRead': chat['unreadMessageCount'] == 0,
      'isOnline': //chat['other']?['lastSeen'] !=
          false,
      'isSent': true,
      'messageType': _getMessageType(chat['lastMessage']?['type']),
      'isArchived': chat['isArchived'] ?? false,
      'isPinned': chat['isPinned'] ?? false,
      'isMuted': chat['other']?['isMuted'] ?? false,
    };
  }

  // Helper method to convert string message type to MessageType enum
  MessageType _getMessageType(String? type) {
    switch (type) {
      case 'TEXT':
        return MessageType.TEXT;
      case 'IMAGE':
        return MessageType.IMAGE;
      case 'VIDEO':
        return MessageType.VIDEO;
      case 'AUDIO':
        return MessageType.AUDIO;
      case 'GIF':
        return MessageType.GIF;
      case 'STICKER':
        return MessageType.STICKER;
      case 'FILE':
        return MessageType.FILE;
      case 'DELETED':
        return MessageType.DELETED;
      case 'VM':
        return MessageType.VM;
      default:
        return MessageType.TEXT;
    }
  }

  Future<void> initializeChats() async {
    try {
      List<dynamic> retrievedChats = await fetchChats();

      if (retrievedChats.isNotEmpty) {
        _chatData = retrievedChats.map((chat) => _applyDefaults(chat)).toList();
      } else {
        _chatData = [];
      }
    } catch (error) {
      print('Failed to fetch chats: $error');
      _chatData = [];
    }
  }

  List<Map<String, dynamic>> get activeChats {
    List<Map<String, dynamic>> activeChats =
        _chatData.where((chat) => !chat['isArchived']).toList();
    return _sortChatsByPin(activeChats);
  }

  List<Map<String, dynamic>> get archivedChats {
    List<Map<String, dynamic>> archivedChats =
        _chatData.where((chat) => chat['isArchived']).toList();
    return _sortChatsByPin(archivedChats);
  }

  void archiveChat(Map<String, dynamic> chat) {
    chat['isArchived'] = true;
  }

  void addChat(Map<String, dynamic> chat) {
    chat = _applyDefaults(chat);
    chat['isArchived'] = false;
    _chatData.add(chat);
  }

  void deleteChat(Map<String, dynamic> chat) {
    _chatData.remove(chat);
  }

  void pinChat(Map<String, dynamic> chat) {
    chat['isPinned'] = true;
  }

  void unpinChat(Map<String, dynamic> chat) {
    chat['isPinned'] = false;
  }

  void muteChat(Map<String, dynamic> chat) {
    chat['isMuted'] = true;
  }

  void unmuteChat(Map<String, dynamic> chat) {
    chat['isMuted'] = false;
  }

  List<Map<String, dynamic>> _sortChatsByPin(List<Map<String, dynamic>> chats) {
    chats.sort((a, b) {
      if (a['isPinned'] && !b['isPinned']) return -1;
      if (!a['isPinned'] && b['isPinned']) return 1;
      return 0;
    });
    return chats;
  }
}
