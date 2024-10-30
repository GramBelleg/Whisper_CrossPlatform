import 'package:equatable/equatable.dart';

abstract class SocketEvent extends Equatable {
  const SocketEvent();

  @override
  List<Object> get props => [];
}

class ConnectSocket extends SocketEvent {
  final String token;
  const ConnectSocket(this.token);

  @override
  List<Object> get props => [token];
}

class LoadMessages extends SocketEvent {
  final int chatId;

  const LoadMessages(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class ReceiveMessage extends SocketEvent {
  final Map<String, dynamic> data;
  const ReceiveMessage(this.data);
  @override
  List<Object> get props => [data];
}

class SendMessage extends SocketEvent {
  final String inputMessage;
  final int chatId;
  final int? senderId;
  const SendMessage(this.inputMessage, this.chatId, this.senderId);

  @override
  List<Object> get props => [inputMessage, chatId, senderId ?? 0];
}
