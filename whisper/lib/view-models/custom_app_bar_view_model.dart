import 'package:whisper/global_cubits/global_cubit_provider.dart';
import 'package:whisper/services/fetch_message_by_id.dart';

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

  Future<void> editMessage(int messageId) async {
    try {
      final message = await fetchMessage(messageId);
      print("hiiiiiiiiiiiiiii");
      GlobalCubitProvider.messagesCubit.editMessage(messageId, message.content);
    } catch (e) {
      throw Exception("Error editing message: $e");
    }
  }
}
