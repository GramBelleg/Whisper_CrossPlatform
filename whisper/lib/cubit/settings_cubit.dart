import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:whisper/components/helpers.dart';
import 'package:whisper/models/user_state.dart';
import 'package:whisper/services/fetch_user_info.dart';
import 'package:whisper/services/send_confirmation_code_email.dart';
import 'package:whisper/services/verify_email_code.dart';
import 'package:whisper/services/read_file.dart';
import 'package:whisper/services/shared_preferences.dart';
import 'package:whisper/services/update_user_field.dart';
import 'package:whisper/socket.dart';
part 'setting_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final socket = SocketService.instance.socket;

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

  String nameStateUpdate = '';
  String usernameStateUpdate = '';
  String emailStateUpdate = '';
  String phoneNumberStateUpdate = '';
  String bioStateUpdate = '';

  SettingsCubit()
      : nameController = TextEditingController(),
        usernameController = TextEditingController(),
        phoneController = TextEditingController(),
        emailController = TextEditingController(),
        bioController = TextEditingController(),
        super(SettingsLoading());

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
        nameState: userState!.name,
        usernameState: userState.username,
        emailState: userState.email,
        phoneNumberState: userState.phoneNumber,
        bioState: userState.bio,
        nameStateUpdate: nameStateUpdate,
        usernameStateUpdate: usernameStateUpdate,
        emailStateUpdate: emailStateUpdate,
        phoneNumberStateUpdate: phoneNumberStateUpdate,
        bioStateUpdate: bioStateUpdate,
        profilePicState: userState.profilePic,
        hasStory: userState.hasStory));
  }

  Future<void> receiveMyProfilePic(String? blobName) async {
    String imageUrl = blobName != null
        ? await generatePresignedUrl(blobName)
        : 'https://ui-avatars.com/api/?background=0a122f&size=100&color=fff&name=${formatName(usernameState)}';
    print("changed Profile Pic");
    final userState = (state as SettingsLoaded).userState;
    userState?.copyWith(profilePic: imageUrl);
    _emitUpdatedState();
  }

  void sendProfilePhoto(String blobName, {bool toRemove = false}) {
    if (!toRemove) {
      socket?.emit('pfp', {'profilePic': blobName});
    } else {
      print("remove my photo");
      socket?.emit('pfp', {'profilePic': null});
    }
  }

  void removeProfilePic() {
    sendProfilePhoto('', toRemove: true);
    _emitUpdatedState();
  }

  Future<void> loadUserState() async {
    try {
      emit(SettingsLoading());
      final userState = await fetchUserInfo();
      if (userState != null) {
        await saveUserState(userState); // save in shared preferences
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
    nameStateUpdate = '';
    usernameStateUpdate = '';
    emailStateUpdate = '';
    phoneNumberStateUpdate = '';
    bioStateUpdate = '';
    _populateControllers(await getUserState() as UserState);
    _emitUpdatedState();
  }

  Future<void> updateHasStoryUserState() async {
    final userState = await getUserState();
    if (!userState!.hasStory) {
      //remove if condation after update backend this
      userState.copyWith(hasStory: !userState.hasStory);
    }
    print("update hasStory");
    _emitUpdatedState();
  }

  // Setter functions for States
  Future<void> setNameStateUpdate(String state) async {
    nameStateUpdate = state;
    _emitUpdatedState();
  }

  Future<void> setUsernameStateUpdate(String state) async {
    usernameStateUpdate = state;
    _emitUpdatedState();
  }

  Future<void> setPhoneNumberStateUpdate(String state) async {
    phoneNumberStateUpdate = state;
    _emitUpdatedState();
  }

  Future<void> setEmailStateUpdate(String state) async {
    emailStateUpdate = state;
    _emitUpdatedState();
  }

  Future<void> setBioStateUpdate(String state) async {
    bioStateUpdate = state;
    _emitUpdatedState();
  }

  Future<void> setAllStateUpdate(String state) async {
    bioStateUpdate = state;
    emailStateUpdate = state;
    phoneNumberStateUpdate = state;
    usernameStateUpdate = state;
    nameStateUpdate = state;

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
      } else if (field == 'userName') {
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
}
