import 'package:whisper/components/own-message/own_message.dart';

class Message {
  String data;
  String time;
  bool sent;
  MessageStatus status;

  Message(this.data, this.time, this.sent, this.status);
}
