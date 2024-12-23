import 'package:whisper/cubit/search_chat_cubit.dart';

class GlobalSearchChatProvider {
  static SearchChatCubit? _searchChatCubit;

  static SearchChatCubit get searchChatCubit {
    _searchChatCubit ??= SearchChatCubit();
    return _searchChatCubit!;
  }

  static void disposeMessagesCubit() {
    _searchChatCubit = null;
  }
}
