// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:whisper/services/fetch-messages.dart';
// import 'dart:collection'; // For SplayTreeSet

// class WebSocketService {
//   late IO.Socket socket;

//   final SplayTreeSet<ChatMessage> messages;

//   WebSocketService(this.messages); // Constructor to receive messages list

//   void connect(String token) {
//     print("send token: $token");
//     // Replace with your server's IP and port
//     // Create the query map
//     final queryMap = token != null && token.isNotEmpty
//         ? {
//             "Authorization": "Bearer $token"
//           } // Include token if not null or empty
//         : {}; // Empty map if token is null or empty

//     // Replace with your server's IP and port
//     socket = IO.io("http://172.20.192.11:5000", <String, dynamic>{
//       "transports": ["websocket"],
//       "autoConnect": false,
//       'query': {'token': "Bearer $token"} // Use the query map
//     });

//     socket.connect();

//     // Listen for successful connection
//     socket.on('connect', (_) {
//       print("Connected to server");
//     });
//     // Listen for successful connection
//     socket.on('connect', (_) {
//       print("Connected to server");
//       // Listen for messages once connected
//       receiveMessages();
//     });
//   }

//   void receiveMessages() {
//     socket.on('receive', (data) {
//       print("Message received: $data");

//       // Update the external messages list
//       messages.add(ChatMessage(
//           id: data['id'],
//           chatId: data['chatId'],
//           senderId: data["senderId"],
//           content: data['content'],
//           forwarded: data['forwarded'],
//           pinned: data['pinned'],
//           selfDestruct: data['selfDestruct'],
//           expiresAfter: data['expiresAfter'],
//           type: data['type'],
//           time: DateTime.parse(data['time'])
//               .add(Duration(hours: 3)), // Adjust for timezone
//           sentAt: DateTime.parse(data['sentAt']),
//           parentMessageId: data['parentMessageId'],
//           parentMessage: data['parentMessage']));
//     });
//   }

//   void sendMessage(String inputMessage, int chatId) {
//     if (inputMessage.isNotEmpty) {
//       // Get the current time
//       DateTime now = DateTime.now();
//       String formattedTime =
//           '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

//       Map<String, dynamic> messageData = {
//         'content': inputMessage,
//         'chatId': chatId,
//         'type': 'TEXT',
//         'forwarded': false,
//         'selfDestruct': true,
//         'expiresAfter': 5,
//         'sentAt': now.toIso8601String() + 'Z',
//       };

//       // Emit the message via socket
//       socket.emit('send', messageData);
//       print('Message sent: $messageData');

//       // Update your UI with the new message if needed
//     }
//   }
// }
