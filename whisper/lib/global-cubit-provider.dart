import 'package:whisper/cubit/messages-cubit.dart';
import 'package:whisper/services/chat-deletion-service.dart';
import 'package:whisper/services/fetch-messages.dart';

class GlobalCubitProvider {
  static MessagesCubit? _messagesCubit;

  static MessagesCubit get messagesCubit {
    _messagesCubit ??= MessagesCubit(ChatViewModel(), ChatDeletionService());
    return _messagesCubit!;
  }

  static void disposeMessagesCubit() {
    _messagesCubit?.disconnectSocket();
    _messagesCubit = null;
  }
}
