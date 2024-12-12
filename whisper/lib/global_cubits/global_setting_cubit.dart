import 'package:whisper/cubit/settings_cubit.dart';

class GlobalSettingsCubitProvider {
  static SettingsCubit? _settingsCubit;

  static SettingsCubit get settingsCubit {
    _settingsCubit ??= SettingsCubit();
    return _settingsCubit!;
  }

  static void disposeMessagesCubit() {
    _settingsCubit = null;
  }
}
