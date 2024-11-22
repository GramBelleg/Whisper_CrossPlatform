// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:whisper/cubit/messages-cubit.dart';
// import 'package:whisper/models/friend.dart';
// import 'package:whisper/services/fetch-message-by-id.dart';
// import 'package:whisper/services/friend-service.dart';
// import 'package:whisper/services/shared-preferences.dart';

// class ForwardMenuViewModel extends Cubit<ForwardMenuState> {
//   final FriendService friendService;
//   final MessagesCubit messagesCubit;

//   ForwardMenuViewModel({
//     required this.friendService,
//     required this.messagesCubit,
//   }) : super(ForwardMenuInitial());

//   Future<void> loadFriends() async {
//     emit(ForwardMenuLoading());
//     try {
//       final friends = await friendService.fetchFriends();
//       emit(ForwardMenuLoaded(friends: friends));
//     } catch (e) {
//       emit(ForwardMenuError(message: "Error loading friends: $e"));
//     }
//   }

//   void toggleFriendSelection(int index) {
//     if (state is ForwardMenuLoaded) {
//       final currentState = state as ForwardMenuLoaded;
//       final selectedIndexes =
//           List<int>.from(currentState.selectedFriendIndexes);

//       if (selectedIndexes.contains(index)) {
//         selectedIndexes.remove(index);
//       } else {
//         selectedIndexes.add(index);
//       }

//       emit(ForwardMenuLoaded(
//         friends: currentState.friends,
//         selectedFriendIndexes: selectedIndexes,
//       ));
//     }
//   }

//   Future<List<String>> forwardMessages({
//     required List<int> selectedMessageIds,
//   }) async {
//     if (state is! ForwardMenuLoaded) return ["Invalid state."];
//     final currentState = state as ForwardMenuLoaded;
//     final selectedIndexes = currentState.selectedFriendIndexes;

//     if (selectedIndexes.isEmpty) return ["No friends selected."];

//     final errors = <String>[];

//     try {
//       final token = await GetToken();
//       final senderId = await GetId();

//       for (final index in selectedIndexes) {
//         final friend = currentState.friends[index];
//         for (final messageId in selectedMessageIds) {
//           try {
//             final message = await fetchMessage(messageId);
//             messagesCubit.sendMessage(
//               content: message.content,
//               chatId: friend.id,
//               senderId: senderId!,
//               parentMessage: message.parentMessage,
//               senderName: friend.name,
//               isReplying: false,
//               isForward: true,
//               forwardedFromUserId: message.sender?.id,
//             );
//           } catch (e) {
//             errors.add(
//                 "Failed to forward message $messageId to ${friend.name}: $e");
//           }
//         }
//       }
//     } catch (e) {
//       errors.add("Error forwarding messages: $e");
//     }

//     return errors;
//   }
// }

// abstract class ForwardMenuState {}

// class ForwardMenuInitial extends ForwardMenuState {}

// class ForwardMenuLoading extends ForwardMenuState {}

// class ForwardMenuLoaded extends ForwardMenuState {
//   final List<Friend> friends;
//   final List<int> selectedFriendIndexes;

//   ForwardMenuLoaded({
//     required this.friends,
//     this.selectedFriendIndexes = const [],
//   });
// }

// class ForwardMenuError extends ForwardMenuState {
//   final String message;

//   ForwardMenuError({required this.message});
// }
