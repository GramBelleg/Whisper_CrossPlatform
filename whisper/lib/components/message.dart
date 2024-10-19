import 'package:whisper/modules/own-message-card.dart';

class Message {
  String data;
  String time;
  bool sent;
  MessageStatus status;

  Message(this.data, this.time, this.sent, this.status);
}
