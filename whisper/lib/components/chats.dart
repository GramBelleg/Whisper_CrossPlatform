import 'chat-card.dart';

class ChatList {
  final List<Map<String, dynamic>> _chatData = [
    {
      'userName': 'Alice',
      'lastMessage': 'Hey! How are you?',
      'time': '10:00 AM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': false,
      'isOnline': true,
      'isSent': true,
      'messageType': MessageType.text,
      'isArchived': false,
    },
    {
      'userName': 'Bob',
      'lastMessage': 'Sent you a picture!',
      'time': '11:00 AM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': false,
      'isOnline': true,
      'isSent': true,
      'messageType': MessageType.image,
      'isArchived': false,
    },
    {
      'userName': 'Charlie',
      'lastMessage': 'Let’s catch up this weekend.',
      'time': '12:00 PM',
      'avatarUrl': 'assets/images/el-gayar.jpg',
      'isRead': true,
      'isOnline': false,
      'isSent': true,
      'messageType': MessageType.text,
      'isArchived': false,
    },
  ];

  List<Map<String, dynamic>> get activeChats {
    return _chatData.where((chat) => !chat['isArchived']).toList();
  }

  List<Map<String, dynamic>> get archivedChats {
    return _chatData.where((chat) => chat['isArchived']).toList();
  }

  void archiveChat(Map<String, dynamic> chat) {
    chat['isArchived'] = true; // Mark the chat as archived
    // Optionally, you could log the action or perform additional logic here.
  }

  void addChat(Map<String, dynamic> chat) {
    chat['isArchived'] = false; // Make sure to mark it as active
    _chatData.add(chat); // Add the chat back to the active list
  }

  void deleteChat(Map<String, dynamic> chat) {
    _chatData.remove(chat); // Remove from active chats
  }
}
