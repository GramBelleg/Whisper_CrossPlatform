import 'package:whisper/models/chat_message.dart';

abstract class MessagesState {}

class MessagseInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessageFetchedSuccessfully extends MessagesState {
  final List<ChatMessage> messages;
  MessageFetchedSuccessfully(this.messages);
}

class SocketConnected extends MessagesState {
  final String message; // Optional: Add a message or additional data if needed
  SocketConnected({this.message = "Connected to server"});
}

class SocketConnectionError extends MessagesState {
  final String error; // Store error message for display
  SocketConnectionError(this.error);
}

class SocketDisconnected extends MessagesState {
  final String message; // Optional: Add a message for disconnection
  SocketDisconnected({this.message = "Disconnected from server"});
}

class MessageFetchedWrong extends MessagesState {}

class MessageSent extends MessagesState {
  final ChatMessage message;
  MessageSent(this.message);
}

class MessageReceived extends MessagesState {
  final ChatMessage message;
  MessageReceived(this.message);
}

// New states for message deletion
class MessagesDeletedSuccessfully extends MessagesState {
  final List<int> deletedIds;
  MessagesDeletedSuccessfully(this.deletedIds);
}

class MessagesDeleteError extends MessagesState {
  final String error;
  MessagesDeleteError(this.error);
}

class MessageEditing extends MessagesState {
  final String content;
  final int messageId;
  MessageEditing(this.content, this.messageId);
}
class MessageEdited extends MessagesState {
  final String content;
  final int messageId;
  MessageEdited(this.content, this.messageId);
}
class MessageEditError extends MessagesState {
  final String error;
  MessageEditError(this.error);
}
