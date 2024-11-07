import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/cubit/messages-state.dart';
import 'package:whisper/models/chat-messages';
import 'package:whisper/services/chat-deletion-service.dart';

import 'package:whisper/services/fetch-messages.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit(this.chatViewModel, this.chatDeletionService)
      : super(MessagseInitial());

  final ChatViewModel chatViewModel;
  final ChatDeletionService chatDeletionService;
  IO.Socket? socket;

  void loadMessages(int chatId) async {
    emit(MessagesLoading());
    try {
      await chatViewModel.fetchChatMessages(chatId);
      List<ChatMessage> fetchedMessages = [];
      for (var chatMessage in chatViewModel.messages) {
        chatMessage.time = chatMessage.time?.toLocal();
        chatMessage.sentAt = chatMessage.sentAt?.toLocal();
        fetchedMessages.add(chatMessage);
      }
      emit(MessageFetchedSuccessfully(fetchedMessages));
    } catch (e) {
      emit(MessageFetchedWrong());
    }
  }

  void connectSocket(String token) {
    print("send token: $token");
    // Disconnect the socket if it's already connected
    if (socket != null && socket!.connected) {
      socket?.disconnect();
    }

    // Remove existing listeners to avoid memory leaks or duplicate calls
    socket?.clearListeners();

    socket = IO.io("http://192.168.1.11:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      'query': {'token': "Bearer $token"}
    });

    socket?.connect();

    socket?.onConnect((_) {
      emit(SocketConnected());
      print("Connected to server");
    });

    // Listen for messages directly and handle them
    socket?.on('receiveMessage', (data) {
      receiveMessage(data); // Handle incoming messages directly
    });

    socket?.onConnectError((error) {
      emit(SocketConnectionError(error.toString()));
      print("Connection error: $error");
    });

    socket?.onDisconnect((_) {
      emit(SocketDisconnected());
      print("Disconnected from server");
    });

    socket?.on('deleteMessage', (data) {
      final ids = List<int>.from(data['Ids']);
      final chatId = data['chatId'];
      receiveDeletedMessage(ids, chatId); // Handle deleted messages
    });

    socket?.on('error', (err) {
      print(err);
    });
  }

  void disconnectSocket() {
    socket?.disconnect();
    print("Socket disconnected");
  }

  void sendMessage(String content, int chatId, int senderId,
      ParentMessage? parentMessage, String senderName, bool isReplying) {
    int nowMillis = DateTime.now().toUtc().millisecondsSinceEpoch;

    print("Current time in milliseconds: $nowMillis");
    // print("zzzzzzzzzzzzzzzzzzzzzzzz ${parentMessage?.content}");
    print("hallllllllllllozeyad${parentMessage}");
    final messageData = {
      'content': content,
      'chatId': chatId,
      'type': 'TEXT',
      'sentAt': DateTime.fromMillisecondsSinceEpoch(nowMillis, isUtc: true)
          .toIso8601String(),
      'parentMessage': parentMessage,
    };

    final newMessage = ChatMessage(
      content: content,
      chatId: chatId,
      senderId: senderId,
      sentAt:
          DateTime.fromMillisecondsSinceEpoch(nowMillis, isUtc: true).toLocal(),
      type: 'TEXT',
      time:
          DateTime.fromMillisecondsSinceEpoch(nowMillis, isUtc: true).toLocal(),
      parentMessage: parentMessage,
    );

    socket?.emit('sendMessage', messageData);
    emit(MessageSent(newMessage));
    print("Message sent: $content");
  }

  // Handle incoming messages without events
  void receiveMessage(Map<String, dynamic> data) {
    ParentMessage? parentMessage;
    if (data['parentMessage'] != null) {
      parentMessage = ParentMessage.fromJson(data['parentMessage']);
    }

    ChatMessage newMessage = ChatMessage(
        id: data['id'],
        chatId: data['chatId'],
        senderId: data["senderId"],
        content: data['content'],
        forwarded: data['forwarded'],
        pinned: data['pinned'],
        selfDestruct: data['selfDestruct'],
        expiresAfter: data['expiresAfter'],
        type: data['type'],
        time: DateTime.parse(data['time']).toLocal(),
        sentAt: DateTime.parse(data['sentAt']).toLocal(),
        parentMessage: parentMessage,
        isSecret: data['isSecret'],
        isAnnouncement: data['isAnnouncement']);
    print(newMessage.toString());
//mentions->list
    // Emit a state indicating the message has been received
    print("daaaaaaaaaaaamn ${newMessage.toString()}");
    emit(MessageReceived(newMessage));
    print("Message received: ${data["content"]}");
  }

  Future<void> deleteMessage(int chatId, List<int> ids) async {
    emit(MessagesLoading());
    try {
      emit(MessagesDeletedSuccessfully(ids));

      await chatDeletionService.deleteMessages(chatId, ids);
      //chatViewModel.messages.removeWhere((message) => ids.contains(message.id));
      // Ensure you have this state defined
      print("hhhhhhhhhhhhhh");
    } catch (e) {
      emit(MessagesDeleteError(e.toString()));
    }
  }

  void emitDeleteMessageForEveryone(List<int> ids, int chatId) {
    final data = {
      'Ids': ids,
      'chatId': chatId,
    };

    try {
      // Attempt to emit the delete event to the server
      socket?.emit('deleteMessage', data);
      emit(MessagesDeletedSuccessfully(ids));
      print(
          "Broadcast delete message request for chatId: $chatId with ids: $ids");
    } catch (e) {
      emit(MessagesDeleteError(e.toString()));
      print("Error broadcasting delete message request: $e");
    }
  }

  void receiveDeletedMessage(List<int> ids, int chatId) {
    try {
      // Handle incoming delete event and remove messages locally
      emit(MessagesDeletedSuccessfully(ids));
      print("Messages deleted from chatId: $chatId with ids: $ids");
    } catch (e) {
      emit(MessagesDeleteError(e.toString()));
      print("Error handling received delete message: $e");
    }
  }
}
