class Message {
  final String content;
  final String time;
  final bool isSent; // true for sent messages, false for received messages

  Message({required this.content, required this.time, required this.isSent});
}
