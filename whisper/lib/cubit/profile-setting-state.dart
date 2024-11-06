part of 'profile-setting-cubit.dart';

@immutable
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final UserState? userState;
  final bool isEditing;

  SettingsLoaded(this.userState, {this.isEditing = false});
}

class SettingsLoadError extends SettingsState {
  final String message;

  SettingsLoadError(this.message);
}
