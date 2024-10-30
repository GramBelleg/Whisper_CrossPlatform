import 'package:equatable/equatable.dart';
import 'package:whisper/services/fetch-messages.dart';

abstract class SocketState extends Equatable {
  const SocketState();
}

class ChatInitial extends SocketState {
  @override
  List<Object> get props => []; // Return List<Object> to match the type
}

class ChatLoading extends SocketState {
  @override
  List<Object> get props => []; // Return List<Object> to match the type
}

class ChatError extends SocketState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message]; // Include the message in props
}

class ChatConnected extends SocketState {
  @override
  List<Object> get props => []; // Return List<Object> to match the type
}

class MessagesLoaded extends SocketState {
  final List<ChatMessage> messages;

  const MessagesLoaded(this.messages);

  @override
  List<Object> get props =>
      messages; // This works since List<ChatMessage> can be treated as List<Object>
}

class MessageReceived extends SocketState {
  final ChatMessage message;

  const MessageReceived(this.message);

  @override
  List<Object> get props => [message]; // Include the message in props
}

class MessageSent extends SocketState {
  final ChatMessage message;

  const MessageSent(this.message);

  @override
  List<Object> get props => [message]; // Include the message in props
}

class MessageAdded extends SocketState {
  final ChatMessage message;

  MessageAdded(this.message);

  @override
  List<Object> get props => [message]; // Include the message in props
}

class MessageUpdated extends SocketState {
  final ChatMessage message;

  MessageUpdated(this.message);
  @override
  List<Object> get props => [message]; // Include the message in props
}
