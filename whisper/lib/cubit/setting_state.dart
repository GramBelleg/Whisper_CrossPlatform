part of 'settings_cubit.dart';

@immutable
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final UserState? userState;
  bool isEditing;
  bool hasStory;

  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  late CustomPhoneController phoneController = CustomPhoneController();

  String nameState;
  String usernameState;
  String emailState;
  String phoneNumberState;
  String bioState;
  String profilePicState;
  String nameStateUpdate;
  String usernameStateUpdate;
  String emailStateUpdate;
  String phoneNumberStateUpdate;
  String bioStateUpdate;

  SettingsLoaded(
      {required this.userState,
      this.isEditing = false,
      required this.nameController,
      required this.usernameController,
      required this.emailController,
      required this.bioController,
      required this.phoneController,
      this.nameState = '',
      this.usernameState = '',
      this.emailState = '',
      this.phoneNumberState = '',
      this.bioState = '',
      this.profilePicState = '',
      this.nameStateUpdate = '',
      this.usernameStateUpdate = '',
      this.emailStateUpdate = '',
      this.phoneNumberStateUpdate = '',
      this.bioStateUpdate = '',
      this.hasStory = false});
}

class SettingsSaved extends SettingsState {
  final String message;

  SettingsSaved(this.message);
}

class SettingsLoadError extends SettingsState {
  final String message;

  SettingsLoadError(this.message);
}

class SettingsUpdated extends SettingsState {
  final UserState userState;

  SettingsUpdated(this.userState);
}

class SettingsEditing extends SettingsState {
  final bool isEditing;

  SettingsEditing(this.isEditing);
}

class SettingsReset extends SettingsState {
  final String message;

  SettingsReset(this.message);
}

class SettingsInvalid extends SettingsState {
  final String message;

  SettingsInvalid(this.message);
}
