import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/models/chat.dart';
import 'package:whisper/services/chats_services/mute_service.dart';
import 'package:whisper/services/chats_services/unmute_service.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/socket.dart';
import '../services/chats_services/fetch_chats.dart';
import 'package:whisper/models/last_message.dart';

class ChatListCubit extends Cubit<List<Chat>> {
  ChatListCubit() : super([]);
  int myId = 0;

  /// Fetch and initialize chats from the API
  Future<void> initializeChats() async {
    await loadChats();
    myId = (await getId())!;
  }

  /// Load chats from the API
  Future<void> loadChats() async {
    try {
      List<dynamic> retrievedChats = await fetchChats();

      if (retrievedChats.isNotEmpty) {
        print("Fetched chats successfully $retrievedChats");
        List<Chat> chats =
            retrievedChats.map((chatJson) => _JSONIntoChat(chatJson)).toList();
        chats.map((chat) => print("chat in load ${chat.toJson()}"));
        emit(_sortChatsByTime(chats));
      } else {
        emit([]);
      }
    } catch (error) {
      print('Failed to fetch chats: $error');
      emit([]);
    }
  }

  void createChat(
    String type,
    String? name,
    String? pictureBlobName,
    int? senderKey,
    List<int> usersId,
  ) {
    // Insert myID at the beginning of the usersId list
    usersId.insert(0, myId);

    // Prepare the payload
    final payload = {
      'type': type,
      'name': name,
      'picture': pictureBlobName, // Use the updated pictureUrl variable
      'senderKey': senderKey,
      'users': usersId, // List of user IDs, with myID at the beginning
    };
    print("payload $payload");
    // Emit the event with the payload to create the chat
    SocketService.instance.socket?.emit('createChat', payload);
  }

  /// Add a new chat
  void addChat(Map<String, dynamic> chatJson) {
    Chat chat = _JSONIntoChat(chatJson);
    List<Chat> updatedChats = List.from(state)..add(chat);
    emit(_sortChatsByTime(updatedChats));
  }

  /// Delete a chat group/channel
  void deleteChat(Chat chat) {
    List<Chat> updatedChats = List.from(state)..remove(chat);
    SocketService.instance.socket?.emit('deleteChat', {
      'chatId':
          chat.chatId, // The identifier for the group/channel to be deleted
    });
    emit(updatedChats);
  }

  // to de leave group/channel

  /// leave a chat group/channel
  void leaveChat(Chat chat) {
    print("leave chat ${chat.chatId} ");
    List<Chat> updatedChats = List.from(state)..remove(chat);

    SocketService.instance.socket?.emit('leaveChat', {
      'chatId':
          chat.chatId, // The identifier for the group/channel to be deleted
    });
    emit(updatedChats);
  }

  /// Mute a chat
  Future<void> muteChat(Chat chat, int selectedOption) async {
    Future<bool> success = muteChatService(chat.chatId, selectedOption);
    List<Chat> updatedChats;
    if (await success) {
      updatedChats = state.map((c) {
        return c == chat ? c.copyWith(isMuted: true) : c;
      }).toList();
      emit(updatedChats);
    }
  }

  /// Unmute a chat
  Future<void> unmuteChat(Chat chat) async {
    Future<bool> success = unmuteChatService(chat.chatId);
    List<Chat> updatedChats;
    if (await success) {
      updatedChats = state.map((c) {
        return c == chat ? c.copyWith(isMuted: false) : c;
      }).toList();
      emit(updatedChats);
    }
  }

  /// Unmute a chat
  Future<void> receiveUnmuteChat(int chatId) async {
    List<Chat> updatedChats = state.map((c) {
      return c.chatId == chatId ? c.copyWith(isMuted: false) : c;
    }).toList();
    emit(updatedChats);
  }

  /// Receive delete chat
  Future<void> receiveDeleteChat(int chatId) async {
    List<Chat> updatedChats = state.where((c) => c.chatId != chatId).toList();
    emit(updatedChats);
  }

  /// Receive Leave chat
  Future<void> receiveLeaveChat(int chatId) async {
    List<Chat> updatedChats = state.where((c) => c.chatId != chatId).toList();
    emit(updatedChats);
  }

  List<Chat> _sortChatsByTime(List<Chat> chats) {
    chats.sort((a, b) {
      // Parse time string to DateTime, and handle invalid formats gracefully
      DateTime? aTime = _parseDateTime(a.time);
      DateTime? bTime = _parseDateTime(b.time);

      if (aTime == null || bTime == null) {
        return 0; // If either date is invalid, don't reorder them
      }

      return bTime.compareTo(aTime); // Sort in descending order
    });
    return chats;
  }

// Helper method to safely parse date
  DateTime? _parseDateTime(String timeString) {
    try {
      return DateTime.parse(timeString);
    } catch (e) {
      throw Exception('Failed to load chats');

      // print("Error parsing date: $e");
      // return null; // Return null if the date format is invalid
    }
  }

  Chat _JSONIntoChat(Map<String, dynamic> chatJson) {
    bool isOnline = chatJson['lastSeen'] != null &&
        DateTime.now()
                .difference(DateTime.parse(chatJson['lastSeen']))
                .inMinutes <
            5;

    // Handling null lastMessage field
    var lastMessageJson = chatJson['lastMessage'];
    LastMessage lastMessage;
    if (lastMessageJson != null) {
      lastMessage = LastMessage.fromJson(lastMessageJson);
    } else {
      lastMessage =
          LastMessage.initLastMessage(); // Use a default or empty value
    }

    return Chat.fromJson(chatJson, isOnline, lastMessage);
  }

  // Setup all socket listeners
  void setupSocketListeners() {
    // Listen for chatsList updates via socket
    SocketService.instance.socket?.on('deleteChat', (data) {
      print("receive deleteChat $data");
      receiveDeleteChat(data);
    });
    SocketService.instance.socket?.on('unmuteChat', (data) {
      print("receive unmuteChat $data");
      receiveUnmuteChat(data);
    });
    SocketService.instance.socket?.on('leaveChat', (data) {
      print("receive unmuteChat $data");
      receiveLeaveChat(data);
    });
  }
}
