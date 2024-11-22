import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/cubit/messages-cubit.dart';
import 'package:whisper/models/friend.dart';
import 'package:whisper/services/fetch-message-by-id.dart';
import 'package:whisper/services/friend-service.dart';
import 'package:whisper/services/shared-preferences.dart';

class ForwardMenuCubit extends Cubit<ForwardMenuState> {
  final FriendService _friendService;
  final MessagesCubit _messagesCubit;

  ForwardMenuCubit(this._friendService, this._messagesCubit)
      : super(ForwardMenuInitial());

  Future<void> loadFriends() async {
    try {
      emit(ForwardMenuLoading());
      final friends = await _friendService.fetchFriends();
      emit(ForwardMenuLoaded(friends));
    } catch (e) {
      emit(ForwardMenuError("Error loading friends: $e"));
    }
  }

  void toggleFriendSelection(int index) {
    if (state is ForwardMenuLoaded) {
      final currentState = state as ForwardMenuLoaded;
      final selectedFriends =
          List<int>.from(currentState.selectedFriendIndexes);

      if (selectedFriends.contains(index)) {
        selectedFriends.remove(index);
      } else {
        selectedFriends.add(index);
      }

      emit(ForwardMenuLoaded(
        currentState.friends,
        selectedFriendIndexes: selectedFriends,
      ));
    }
  }

  Future<List<String>> forwardMessages(
      List<int> selectedFriendIndexes, List<int> selectedMessageIds) async {
    if (selectedFriendIndexes.isEmpty) {
      return ["No friends selected."];
    }

    final errors = <String>[];

    try {
      final token = await GetToken();
      final senderId = await GetId();

      if (token == null || senderId == null) {
        return ["Failed to retrieve user credentials."];
      }

      final currentState = state as ForwardMenuLoaded;

      for (final index in selectedFriendIndexes) {
        final friend = currentState.friends[index];
        for (final messageId in selectedMessageIds) {
          try {
            final message = await fetchMessage(messageId);

            // Send the message using the MessagesCubit
            _messagesCubit.sendMessage(
              message.content, // Message content
              friend.id, // Chat ID of the friend
              senderId, // Current sender's ID
              message.parentMessage, // Parent message (if any)
              friend.name, // Friend's name
              false, // Is it a reply?
              true, // Is it a forwarded message?
              message.sender?.id, // Original sender's ID (if applicable)
            );
            print("Forwarding message to ${friend.name}: ${message.content}");
          } catch (e) {
            errors.add(
                "Failed to forward message $messageId to ${friend.name}: $e");
          }
        }
      }
    } catch (e) {
      errors.add("Error forwarding messages: $e");
    }

    return errors;
  }
}

abstract class ForwardMenuState {}

class ForwardMenuInitial extends ForwardMenuState {}

class ForwardMenuLoading extends ForwardMenuState {}

class ForwardMenuLoaded extends ForwardMenuState {
  final List<Friend> friends;
  final List<int> selectedFriendIndexes;

  ForwardMenuLoaded(this.friends, {this.selectedFriendIndexes = const []});
}

class ForwardMenuError extends ForwardMenuState {
  final String message;

  ForwardMenuError(this.message);
}
