// import 'dart:convert';
// import 'package:bloc/bloc.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:image_picker/image_picker.dart';
// import 'package:whisper/services/shared-preferences.dart';

// // Define states
// abstract class SocketState {}

// class SocketInitial extends SocketState {}

// class SocketConnected extends SocketState {}

// class SocketDisconnected extends SocketState {}

// class ProfilePictureUpdated extends SocketState {
//   final String imageUrl;
//   ProfilePictureUpdated(this.imageUrl);
// }

// class ProfilePictureRemoved extends SocketState {}

// // Define Socket Cubit
// class SocketCubit extends Cubit<SocketState> {
//   late IO.Socket socket;

//   SocketCubit() : super(SocketInitial());

//   Future<void> connect() async {
//     String? token = await GetToken();
//     // Initialize socket connection
//     socket = IO.io("http://172.20.192.1:5000", <String, dynamic>{
//       "transports": ["websocket"],
//       "autoConnect": false,
//       'query': {'token': "Bearer $token"}
//     });

//     socket.connect();

//     // Emit state on connection
//     socket.onConnect((_) {
//       print('connected');
//       emit(SocketConnected());
//     });

//     // Handle profile picture update confirmation
//     socket.on('pfp', (data) {
//       final imageUrl = data['profilePic'] as String;
//       emit(ProfilePictureUpdated(imageUrl));
//     });

//     // Handle profile picture removal confirmation
//     socket.on('profile_picture_removed', (_) {
//       emit(ProfilePictureRemoved());
//     });

//     socket.onDisconnect((_) {
//       print('disconnected');
//       emit(SocketDisconnected());
//     });
//   }

//   Future<void> setProfilePicture() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       // Convert image to Base64 string
//       final bytes = await pickedFile.readAsBytes();
//       final base64Image = base64Encode(bytes);

//       // Emit the event with the encoded image data
//       socket.emit('pfp', {'profilePic': base64Image});
//     }
//   }

//   void removeProfilePicture() {
//     socket.emit('remove_profile_picture');
//   }

//   void disconnect() {
//     socket.disconnect();
//     emit(SocketDisconnected());
//   }

//   @override
//   Future<void> close() {
//     socket.dispose();
//     return super.close();
//   }
// }
