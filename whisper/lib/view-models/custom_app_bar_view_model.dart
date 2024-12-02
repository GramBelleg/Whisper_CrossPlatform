import 'package:whisper/global_cubit_provider.dart';

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
