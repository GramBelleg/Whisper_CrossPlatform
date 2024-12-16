import 'package:whisper/cubit/messages_cubit.dart';
import 'package:whisper/services/chat_deletion_service.dart';
import 'package:whisper/services/fetch_chat_messages.dart';

class GlobalCubitProvider {
  static MessagesCubit? _messagesCubit;

  static MessagesCubit get messagesCubit {
    _messagesCubit ??= MessagesCubit(ChatViewModel(), ChatDeletionService());
    return _messagesCubit!;
  }

  static void disposeMessagesCubit() {
    // _messagesCubit?.disconnectSocket();
    _messagesCubit = null;
  }
}
