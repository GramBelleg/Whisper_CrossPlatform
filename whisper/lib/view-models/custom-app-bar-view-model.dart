// custom_app_bar_view_model.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whisper/cubit/messages-cubit.dart';
import 'package:whisper/global-cubit-provider.dart';

class CustomAppBarViewModel {
  CustomAppBarViewModel();

  Future<void> deleteMessagesForMe(
      int chatId, List<int> selectedMessageIds) async {
    try {
      await GlobalCubitProvider.messagesCubit
          .deleteMessage(chatId, selectedMessageIds);
    } catch (e) {
      throw Exception("Error deleting messages for user: $e");
    }
  }

  Future<void> deleteMessagesForEveryone(
      int chatId, List<int> selectedMessageIds) async {
    try {
      GlobalCubitProvider.messagesCubit
          .emitDeleteMessageForEveryone(selectedMessageIds, chatId);
    } catch (e) {
      throw Exception("Error deleting messages for everyone: $e");
    }
  }
}
