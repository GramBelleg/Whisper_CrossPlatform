import 'package:intl/intl.dart'; // Import for date formatting
import '../services/chats-services.dart';
import 'chat-card.dart'; // Assuming this imports MessageType and other relevant definitions

class ChatList {
  List<Map<String, dynamic>> _chatData = [];

  Map<String, dynamic> _applyDefaults(Map<String, dynamic> chat) {
    // Parse the createdAt time if it exists
    String timeString = chat['lastMessage']?['createdAt'] ?? '';
    DateTime messageTime = timeString.isNotEmpty
        ? DateTime.parse(timeString).toLocal() // Convert UTC to local time
        : DateTime.now();

    // Calculate the difference from now
    Duration difference = DateTime.now().difference(messageTime);

    // Format the time according to your criteria
    String formattedTime;
    if (difference.inDays == 0) {
      // Show hours and minutes for today
      formattedTime = DateFormat.jm().format(messageTime); // e.g., 3:30 PM
    } else if (difference.inDays < 7) {
      // Show the day of the week for messages within the last week
      formattedTime = DateFormat.E().format(messageTime); // e.g., Mon
    } else {
      // Show full date for older messages
      formattedTime = DateFormat('dd MMM').format(messageTime); // e.g., 01 Jan
    }

    return {
      'chatid': chat['lastMessage']?['chatId'],
      'userName': chat['userName'] ??
          'User ${chat['id']}', // Use 'id' if 'userName' is null
      'lastMessage': chat['lastMessage']?['content'] ??
          '', // Handle nested lastMessage content
      'time': formattedTime, // Keep original time for reference
      'avatarUrl': chat['avatarUrl'] ?? 'assets/images/el-gayar.jpg',
      'isRead': chat['unreadMessageCount'] == 0,
      'isOnline': chat['isOnline'] ?? true,
      'isSent': chat['isSent'] ?? false,
      'messageType': _getMessageType(
          chat['lastMessage']?['type']), // Convert type to MessageType enum
      'isArchived': chat['isArchived'] ?? false,
      'isPinned': chat['lastMessage']?['pinned'] ?? false,
      'isMuted': chat['isMuted'] ?? false,
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
        return MessageType.TEXT; // Default to text if type is unknown
    }
  }

  Future<void> initializeChats() async {
    try {
      List<dynamic> retrievedChats = await fetchChats();

      if (retrievedChats != null && retrievedChats.isNotEmpty) {
        _chatData = retrievedChats.map((chat) => _applyDefaults(chat)).toList();
      } else {
        _chatData = []; // Handle empty data scenario
      }
    } catch (error) {
      // Handle error appropriately
      print('Failed to fetch chats: $error');
      _chatData = []; // Ensure chat list is empty on error
    }
  }

  List<Map<String, dynamic>> get activeChats {
    List<Map<String, dynamic>> activeChats =
        _chatData.where((chat) => !chat['isArchived']).toList();
    return _sortChatsByPin(activeChats); // Reuse the sorting function
  }

  List<Map<String, dynamic>> get archivedChats {
    List<Map<String, dynamic>> archivedChats =
        _chatData.where((chat) => chat['isArchived']).toList();
    return _sortChatsByPin(archivedChats); // Reuse the sorting function
  }

  void archiveChat(Map<String, dynamic> chat) {
    chat['isArchived'] = true; // Mark the chat as archived
  }

  void addChat(Map<String, dynamic> chat) {
    chat = _applyDefaults(chat); // Apply default values before adding
    chat['isArchived'] = false; // Make sure to mark it as active
    _chatData.add(chat); // Add the chat back to the active list
  }

  void deleteChat(Map<String, dynamic> chat) {
    _chatData.remove(chat); // Remove from active chats
  }

  void pinChat(Map<String, dynamic> chat) {
    chat['isPinned'] = true; // Pin the chat
  }

  void unpinChat(Map<String, dynamic> chat) {
    chat['isPinned'] = false; // Unpin the chat
  }

  // New method to mute a chat
  void muteChat(Map<String, dynamic> chat) {
    chat['isMuted'] = true; // Mute the chat
  }

  // New method to unmute a chat
  void unmuteChat(Map<String, dynamic> chat) {
    chat['isMuted'] = false; // Unmute the chat
  }

  // Helper method to sort chats by pin status
  List<Map<String, dynamic>> _sortChatsByPin(List<Map<String, dynamic>> chats) {
    chats.sort((a, b) {
      if (a['isPinned'] && !b['isPinned']) return -1;
      if (!a['isPinned'] && b['isPinned']) return 1;
      return 0; // Keep order if both are pinned or unpinned
    });
    return chats;
  }
}
