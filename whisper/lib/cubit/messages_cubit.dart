import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/cubit/messages_state.dart';
import 'package:whisper/models/chat_message.dart';
import 'package:whisper/models/forwarded_from.dart';
import 'package:whisper/models/parent_message.dart';
import 'package:whisper/models/sender.dart';
import 'package:whisper/services/chat_deletion_service.dart';
import 'package:whisper/services/fetch_chat_messages.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:whisper/socket.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final ChatViewModel _chatViewModel;
  final ChatDeletionService chatDeletionService;
  final socket = SocketService.instance.socket;
  MessagesCubit(this._chatViewModel, this.chatDeletionService)
      : super(MessagseInitial());

  void loadMessages(int chatId) async {
    emit(MessagesLoading());
    try {
      await _chatViewModel.fetchChatMessages(chatId);
      final fetchedMessages = _processFetchedMessages();
      emit(MessageFetchedSuccessfully(fetchedMessages));
    } catch (e) {
      emit(MessageFetchedWrong());
    }
  }

  List<ChatMessage> _processFetchedMessages() {
    return _chatViewModel.messages.map((message) {
      message.time = message.time?.toLocal();
      message.sentAt = message.sentAt?.toLocal();
      return message;
    }).toList();
  }

  void setupSocketListeners() {
    socket?.onConnect((_) {
      emit(SocketConnected());
    });

    socket?.on('message', (data) {
      _handleReceivedMessage(data);
    });

    socket?.onConnectError((error) {
      emit(SocketConnectionError(error.toString()));
    });

    socket?.onDisconnect((_) {
      emit(SocketDisconnected());
    });

    socket?.on('deleteMessage', (data) {
      _handleDeletedMessage(data);
    });

    socket?.on('error', (err) {
      print(err);
    });
  }

  void disconnectSocket() {
    socket?.disconnect();
  }

  void sendMessage(
      {required String content,
      required int chatId,
      required int senderId,
      ParentMessage? parentMessage,
      required String senderName,
      required bool isReplying,
      required bool isForward,
      int? forwardedFromUserId,
      String? media,
      String? extension,
      required String type}) {
    int nowMillis = DateTime.now().toUtc().millisecondsSinceEpoch;

    final messageData = {
      'content': content,
      'chatId': chatId,
      'type': type,
      'sentAt': DateTime.fromMillisecondsSinceEpoch(nowMillis, isUtc: true)
          .toIso8601String(),
      'parentMessageId': parentMessage == null ? null : parentMessage.id,
      'forwarded': isForward,
      'forwardedFromUserId': isForward == true ? forwardedFromUserId : null,
      'media': media == null ? null : media,
      'extension': extension,
    };
    final sender = Sender(id: senderId, userName: senderName);
    final newMessage = ChatMessage(
      content: content,
      chatId: chatId,
      sender: sender,
      sentAt:
          DateTime.fromMillisecondsSinceEpoch(nowMillis, isUtc: true).toLocal(),
      type: type,
      time:
          DateTime.fromMillisecondsSinceEpoch(nowMillis, isUtc: true).toLocal(),
      parentMessage: parentMessage,
      media: media,
      extension: extension,
    );
    socket?.emit('message', messageData);
    emit(MessageSent(newMessage));
  }

  void _handleReceivedMessage(Map<String, dynamic> data) {
    final newMessage = _parseMessage(data);
    emit(MessageReceived(newMessage));
  }

  ChatMessage _parseMessage(Map<String, dynamic> data) {
    final parentMessage = data['parentMessage'] != null
        ? ParentMessage.fromJson(data['parentMessage'])
        : null;
    final forwardedFrom = data['forwardedFrom'] != null
        ? ForwardedFrom.fromJson(data['forwardedFrom'])
        : null;
    return ChatMessage(
      id: data['id'],
      chatId: data['chatId'],
      sender: data['sender'] != null ? Sender.fromJson(data['sender']) : null,
      content: data['content'],
      mentions:
          data['mentions'] != null ? List<int>.from(data['mentions']) : null,
      media: data['media'],
      time:
          data['time'] != null ? DateTime.parse(data['time']).toLocal() : null,
      sentAt: data['sentAt'] != null
          ? DateTime.parse(data['sentAt']).toLocal()
          : null,
      read: data['read'] ?? false,
      delivered: data['delivered'] ?? false,
      forwarded: data['forwarded'] ?? false,
      pinned: data['pinned'] ?? false,
      edited: data['edited'] ?? false,
      selfDestruct: data['selfDestruct'] ?? false,
      isAnnouncement: data['isAnnouncement'] ?? false,
      isSecret: data['isSecret'] ?? false,
      expiresAfter: data['expiresAfter'],
      type: data['type'],
      parentMessage: parentMessage,
      forwardedFrom: forwardedFrom,
      extension: data['extension'],
    );
  }

  Future<void> deleteMessage(int chatId, List<int> ids) async {
    emit(MessagesLoading());
    try {
      emit(MessagesDeletedSuccessfully(ids));
      await chatDeletionService.deleteMessages(chatId, ids);
    } catch (e) {
      emit(MessagesDeleteError(e.toString()));
    }
  }

  void emitDeleteMessageForEveryone(List<int> ids, int chatId) {
    final data = {
      'messages': ids,
      'chatId': chatId,
    };

    try {
      emit(MessagesDeletedSuccessfully(ids));
      socket?.emit('deleteMessage', data);
      print("i'm her for deleting ${data}");
    } catch (e) {
      emit(MessagesDeleteError(e.toString()));
    }
  }

  void _handleDeletedMessage(Map<String, dynamic> data) {
    final ids = List<int>.from(data['messages']);
    final chatId = data['chatId'];
    emit(MessagesDeletedSuccessfully(ids));
  }
}
