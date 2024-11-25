import 'package:whisper/cubit/messages-cubit.dart';
import 'package:whisper/services/chat-deletion-service.dart';
import 'package:whisper/services/fetch-messages.dart';

class GlobalCubitProvider {
  // Private static instance of MessagesCubit
  static MessagesCubit? _messagesCubit;

  // Getter for lazy initialization
  static MessagesCubit get messagesCubit {
    // If null, create an instance with required dependencies
    _messagesCubit ??= MessagesCubit(ChatViewModel(), ChatDeletionService());
    return _messagesCubit!;
  }

  // Optional: Cleanup method
  static void disposeMessagesCubit() {
    _messagesCubit?.disconnectSocket();
    _messagesCubit = null; // Reset instance if needed
  }
}
