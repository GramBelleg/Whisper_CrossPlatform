part of 'profile-setting-cubit.dart';

@immutable
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final UserState? userState;
  bool isEditing;

  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  late TextEditingController phoneController;

  String nameState;
  String usernameState;
  String emailState;
  String phoneNumberState;
  String bioState;

  SettingsLoaded({
    this.userState,
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
  });
}

class SettingsLoadError extends SettingsState {
  final String message;

  SettingsLoadError(this.message);
}
