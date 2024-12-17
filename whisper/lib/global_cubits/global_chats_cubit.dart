import 'package:whisper/cubit/chats_cubit.dart';

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
