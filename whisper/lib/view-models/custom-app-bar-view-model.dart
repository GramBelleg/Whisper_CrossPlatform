// custom_app_bar_view_model.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/cubit/messages-cubit.dart';

class CustomAppBarViewModel {
  final MessagesCubit messagesCubit;

  CustomAppBarViewModel({required this.messagesCubit});

  Future<void> deleteMessagesForMe(
      int chatId, List<int> selectedMessageIds) async {
    try {
      await messagesCubit.deleteMessage(chatId, selectedMessageIds);
    } catch (e) {
      throw Exception("Error deleting messages for user: $e");
    }
  }

  Future<void> deleteMessagesForEveryone(
      int chatId, List<int> selectedMessageIds) async {
    try {
      messagesCubit.emitDeleteMessageForEveryone(selectedMessageIds, chatId);
    } catch (e) {
      throw Exception("Error deleting messages for everyone: $e");
    }
  }
}
