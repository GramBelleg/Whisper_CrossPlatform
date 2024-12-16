import 'package:whisper/cubit/groups_cubit.dart';

class GlobalGroupsProvider {
  static GroupsCubit? _groupsCubit;

  static GroupsCubit get groupsCubit {
    _groupsCubit ??= GroupsCubit();
    return _groupsCubit!;
  }

  static void disposeMessagesCubit() {
    // _groupsCubit?.disconnectSocket();
    _groupsCubit = null;
  }
}
