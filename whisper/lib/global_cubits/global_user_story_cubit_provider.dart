import 'package:whisper/cubit/user_story_cubit.dart';

class GlobalUserStoryCubitProvider {
  static UserStoryCubit? _userStoryCubit;

  static UserStoryCubit get userStoryCubit {
    _userStoryCubit ??= UserStoryCubit();
    return _userStoryCubit!;
  }

  static void disposeMessagesCubit() {
    _userStoryCubit = null;
  }
}
