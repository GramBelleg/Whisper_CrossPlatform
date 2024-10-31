import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:whisper/bloc/chat-event.dart';
import 'package:whisper/bloc/chat-state.dart';
import 'package:whisper/models/chat-messages';
import 'package:whisper/services/fetch-messages.dart';

class ChatBloc extends Bloc<SocketEvent, SocketState> {
  IO.Socket? socket; // Socket instance for communication
  List<ChatMessage> messages = []; // List to hold chat messages

  ChatBloc() : super(ChatInitial()) {
    // Register event handlers
    on<ConnectSocket>(_onConnectSocket);
    // on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  void _onConnectSocket(ConnectSocket event, Emitter<SocketState> emit) {
    print("send token: ${event.token}"); // Print the token for debugging

    socket = IO.io("http://localhost:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      'query': {'token': "Bearer ${event.token}"} // Use the query map
    });

    if (socket?.connected == true) {
      socket?.disconnect();
    }

    socket?.connect();
    socket?.off(
        'receiveMessage'); // Clear any previous listeners for receiveMessage

    // Listen for successful connection
    socket?.on('connection', (_) {
      emit(ChatConnected());
      print("Connected to server"); // Print success message
    });

    socket?.on('receiveMessage', (data) {
      add(ReceiveMessage(data));
    });
  }

  // Future<void> _onLoadMessages(
  //     LoadMessages event, Emitter<SocketState> emit) async {
  //   emit(ChatLoading());
  //   try {
  //     print("Loading messages for chatId: ${event.chatId}");
  //     List<ChatMessage> chatMessages = await fetchChatMessages(event.chatId);
  //     print("Messages loaded successfully");

  //     // Process each chat message
  //     for (var chatMessage in chatMessages) {
  //       // Ensure chatMessage.time and chatMessage.sentAt are non-null
  //       chatMessage.time = chatMessage.time?.toLocal();
  //       chatMessage.sentAt =
  //           chatMessage.sentAt?.toLocal(); // Handle potential null
  //       messages.add(chatMessage);
  //     }
  //     for (var x in messages) print(x.content);
  //     emit(MessagesLoaded(messages)); // Emit updated messages state
  //   } catch (e) {
  //     print("Error loading messages: $e"); // Log the error for debugging
  //     emit(ChatError(
  //         "Failed to load messages: ${e.toString()}")); // Emit an error state with message
  //   }
  // }

  void _onSendMessage(SendMessage event, Emitter<SocketState> emit) {
    DateTime now = DateTime.now().toUtc();
    final messageData = {
      'content': event.inputMessage,
      'chatId': event.chatId,
      'type': 'TEXT',
      'sentAt': now.toIso8601String(),
    };

    final newMessage = ChatMessage(
      content: event.inputMessage,
      chatId: event.chatId,
      senderId: event.senderId,
      sentAt: now.toLocal(),
      type: 'TEXT',
    );

    messages.add(newMessage);
    socket?.emit('sendMessage', messageData);
    // emit(MessageSent(newMessage)); // Emit the sent message state
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<SocketState> emit) {
    print("Message received: $event");

    // Parse the received message
    // DateTime receivedTime =
    // print(receivedTime);
    //int index = messages.indexWhere((msg) => msg.sentAt == receivedTime);

    // if (index != -1) {
    //   print("i found him ");
    //   // Update existing message if found
    //   messages[index] = ChatMessage(
    //       id: event.data['id'],
    //       chatId: event.data['chatId'],
    //       senderId: event.data["senderId"],
    //       content: event.data['content'],
    //       forwarded: event.data['forwarded'],
    //       pinned: event.data['pinned'],
    //       selfDestruct: event.data['selfDestruct'],
    //       expiresAfter: event.data['expiresAfter'],
    //       type: event.data['type'],
    //       time: DateTime.parse(event.data['time']).toLocal(),
    //       sentAt: DateTime.parse(event.data['sentAt'])
    //           .toLocal(), // Use the correct sentAt time
    //       parentMessageId: event.data['parentMessageId'],
    //       parentMessage: event.data['parentMessage']);

    //   // Emit a message updated state
    //   emit(MessageUpdated(messages[index])); // Emit the updated message state
    // } else {
    // Add new message if not found
    ChatMessage newMessage = ChatMessage(
        id: event.data['id'],
        chatId: event.data['chatId'],
        senderId: event.data["senderId"],
        content: event.data['content'],
        forwarded: event.data['forwarded'],
        pinned: event.data['pinned'],
        selfDestruct: event.data['selfDestruct'],
        expiresAfter: event.data['expiresAfter'],
        type: event.data['type'],
        time: DateTime.parse(event.data['time']).toLocal(),
        sentAt: DateTime.parse(event.data['sentAt'])
            .toLocal(), // Use the correct sentAt time
        parentMessageId: event.data['parentMessageId'],
        parentMessage: event.data['parentMessage']);
    print("zizo come here");
    messages.add(newMessage);
    print("zizo come here");
    // Emit a new message state
    emit(MessageAdded(newMessage)); // Emit the new message state
  }
}
