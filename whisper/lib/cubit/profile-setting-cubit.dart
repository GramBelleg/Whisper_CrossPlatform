import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:whisper/components/user-state.dart'; 
import 'package:whisper/services/confirm-code-email-update.dart'; 
import 'package:whisper/services/email-code-update.dart';
import 'package:whisper/services/read-file.dart';
import 'package:whisper/services/shared-preferences.dart'; 
import 'package:whisper/services/update-user-field.dart'; 
import 'package:whisper/socket.dart'; 

part 'profile-setting-state.dart'; 

class SettingsCubit extends Cubit<SettingsState> {
  bool isEditing = false;

  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  late TextEditingController phoneController;

  String nameState = '';
  String usernameState = '';
  String emailState = '';
  String phoneNumberState = '';
  String bioState = '';

  SettingsCubit()
      : nameController = TextEditingController(),
        usernameController = TextEditingController(),
        phoneController = TextEditingController(),
        emailController = TextEditingController(),
        bioController = TextEditingController(),
        super(SettingsInitial());

  // Helper method to update the state
  void _emitUpdatedState() async {
    final userState = await getUserState();
    emit(SettingsLoaded(
      userState: userState,
      isEditing: isEditing,
      nameController: nameController,
      usernameController: usernameController,
      emailController: emailController,
      bioController: bioController,
      phoneController: phoneController,
      nameState: nameState,
      usernameState: usernameState,
      emailState: emailState,
      phoneNumberState: phoneNumberState,
      bioState: bioState,
    ));
  }

  void sendProfilePhoto(String blobName) {
    final socket = SocketService.instance.socket;
    socket?.emit('pfp', {'profilePic': blobName});
  }

  void removeProfilePic() {
    sendProfilePhoto('');
  }

  Future<void> loadUserState() async {
    try {
      final userState = await getUserState();
      if (userState != null) {
        _populateControllers(userState);
        _emitUpdatedState();
      } else {
        emit(SettingsLoadError("User state not found."));
      }
    } catch (e) {
      emit(SettingsLoadError("Error loading user state: $e"));
    }
  }

  void _populateControllers(UserState userState) {
    nameController.text = userState.name;
    usernameController.text = userState.username;
    phoneController.text = userState.phoneNumber;
    emailController.text = userState.email;
    bioController.text = userState.bio;
  }

  Future<void> toggleEditing() async {
    isEditing = !isEditing;
    _emitUpdatedState();
  }

  Future<void> resetStateMessages() async {
    nameState = '';
    usernameState = '';
    emailState = '';
    phoneNumberState = '';
    bioState = '';
    _populateControllers(await getUserState() as UserState);
    _emitUpdatedState();
  }

  // Setter functions for States
  Future<void> setNameState(String state) async {
    nameState = state;
    _emitUpdatedState();
  }

  Future<void> setUsernameState(String state) async {
    usernameState = state;
    _emitUpdatedState();
  }

  Future<void> setPhoneNumberState(String state) async {
    phoneNumberState = state;
    _emitUpdatedState();
  }

  Future<void> setEmailState(String state) async {
    emailState = state;
    _emitUpdatedState();
  }

  Future<void> setBioState(String state) async {
    bioState = state;
    _emitUpdatedState();
  }

  // Update user field (generic update function for each field)
  Future<Map<String, dynamic>> updateField(
      String newValue, String field) async {
    final response = await updateUserField(field, newValue);
    final success = response['success'] ?? false;
    final message = response['success'] ? "Updated" : response['message'];

    if (success) {
      final userState = (state as SettingsLoaded).userState;
      if (field == 'name') {
        userState?.copyWith(name: newValue);
      } else if (field == 'username') {
        userState?.copyWith(username: newValue);
      } else if (field == 'phoneNumber') {
        userState?.copyWith(phoneNumber: newValue);
      } else if (field == 'bio') {
        userState?.copyWith(bio: newValue);
      }
      _emitUpdatedState();
    }

    return {'success': success, 'message': message};
  }

  Future<void> updateProfilePic(String blobName) async {
    String response = await generatePresignedUrl(blobName);
    final userState = (state as SettingsLoaded).userState;
    userState?.copyWith(profilePic: response);
    _emitUpdatedState();
  }

  Future<Map<String, dynamic>> sendCode(
      String email, BuildContext context) async {
    final response = await sendConfirmationCodeEmail(email, context);
    _emitUpdatedState();
    return response;
  }

  Future<Map<String, dynamic>> verifyCode(
      String code, String email, BuildContext context) async {
    final response = await verifyEmailCode(code, email, context);
    if (response['success']) {
      final userState = (state as SettingsLoaded).userState;
      userState?.copyWith(email: email);
      _emitUpdatedState();
    }
    return response;
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
