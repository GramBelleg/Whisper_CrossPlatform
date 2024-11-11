import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/cubit/messages-state.dart';
import 'package:whisper/models/chat-messages';
import 'package:whisper/services/chat-deletion-service.dart';
import 'package:whisper/services/fetch-messages.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../constants/ip-for-services.dart';

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

    socket = IO.io("http://$ip:5000", <String, dynamic>{
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

    // socket?.on('pfp', (data) {
    //   receiveMessage(data); // Handle incoming pic directly
    // });

    socket?.onConnectError((error) {
      emit(SocketConnectionError(error.toString()));
      print("Connection error: $error");
    });

    socket?.onDisconnect((_) {
      emit(SocketDisconnected());
      print("Disconnected from server");
    });
  }

  // void receivePic(Map<String, dynamic> data) {
  //     context.read<SettingsCubit>().setProfilePic(data);
  // }

  void disconnectSocket() {
    socket?.disconnect();
    print("Socket disconnected");
  }

  void sendMessage(String content, int chatId, int senderId) {
    DateTime now = DateTime.now().toUtc();

    final messageData = {
      'content': content,
      'chatId': chatId,
      'type': 'TEXT',
      'sentAt': now.toIso8601String(),
    };

    final newMessage = ChatMessage(
      content: content,
      chatId: chatId,
      senderId: senderId,
      sentAt: now.toLocal(),
      type: 'TEXT',
      time: now.toLocal(),
    );

    socket?.emit('sendMessage', messageData);
    emit(MessageSent(newMessage));
    print("Message sent: $content");
  }

  // Handle incoming messages without events
  void receiveMessage(Map<String, dynamic> data) {
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
      parentMessageId: data['parentMessageId'],
      parentMessage: data['parentMessage'],
    );

    // Emit a state indicating the message has been received
    emit(MessageReceived(
        newMessage)); // Ensure MessageReceived is defined in your state
    print("Message received: ${data["content"]}");
  }

  Future<void> deleteMessage(int chatId, List<int> ids) async {
    emit(MessagesLoading());
    try {
      emit(MessagesDeletedSuccessfully(ids));

      await chatDeletionService.deleteMessages(chatId, ids);
      //chatViewModel.messages.removeWhere((message) => ids.contains(message.id));
      // Ensure you have this state defined
    } catch (e) {
      emit(MessagesDeleteError(e.toString()));
    }
  }

  void deleteMessagesForEveryOne(Map<String, dynamic> data) {}
}
