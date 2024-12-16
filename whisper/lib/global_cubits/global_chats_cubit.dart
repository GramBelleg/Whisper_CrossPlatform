import 'package:whisper/components/chat_list.dart';

class GlobalChatsCubitProvider {
  static ChatListCubit? _chatListCubit;

  static ChatListCubit get chatListCubit {
    _chatListCubit ??= ChatListCubit();
    return _chatListCubit!;
  }

  static void disposeMessagesCubit() {
    _chatListCubit = null;
  }
}
