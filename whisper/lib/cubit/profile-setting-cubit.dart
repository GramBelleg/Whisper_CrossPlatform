import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:whisper/components/user-state.dart';
import 'package:whisper/services/confirm-code-email-update.dart';
import 'package:whisper/services/email-code-update.dart';
import 'package:whisper/services/read-file.dart';
import 'package:whisper/services/shared-preferences.dart'; // Your UserState model
import 'package:whisper/services/update-user-field.dart'; // Assuming this is where the update functions are defined

part 'profile-setting-state.dart'; // This connects to the state file

class SettingsCubit extends Cubit<SettingsState> {
  bool isEditing = false;

  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  late TextEditingController phoneController;

  // State variables for each field
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

  // Load user state
  Future<void> loadUserState() async {
    try {
      UserState? userState = await getUserState();
      if (userState != null) {
        nameController.text = userState.name;
        usernameController.text = userState.username;
        phoneController.text = userState.phoneNumber;
        emailController.text = userState.email;
        bioController.text = userState.bio;

        emit(SettingsLoaded(
          userState: await getUserState(),
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
      } else {
        emit(SettingsLoadError("User state not found."));
      }
    } catch (e) {
      emit(SettingsLoadError("State loading user state: $e"));
    }
  }

  // Toggle editing mode
  Future<void> toggleEditing() async {
    isEditing = !isEditing;
    if (state is SettingsLoaded) {
      emit(SettingsLoaded(
        userState: await getUserState(),
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
  }

  Future<void> resetStateMessages() async {
    // Reset all the state messages
    nameState = '';
    usernameState = '';
    emailState = '';
    phoneNumberState = '';
    bioState = '';

    // Reset all the text controllers to their original values (can be done from the current user state)
    if (state is SettingsLoaded) {
      final userState = (state as SettingsLoaded).userState;

      // Reset the text controllers with the current values from the userState
      nameController.text = userState?.name ?? '';
      usernameController.text = userState?.username ?? '';
      phoneController.text = userState?.phoneNumber ?? '';
      emailController.text = userState?.email ?? '';
      bioController.text = userState?.bio ?? '';

      // Emit the updated state with reset values
      emit(SettingsLoaded(
        userState: await getUserState(),
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
  }

  // Setter functions for States
  Future<void> setNameState(String State) async {
    nameState = State;
    emit(SettingsLoaded(
      userState: await getUserState(),
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

  Future<void> setUsernameState(String State) async {
    usernameState = State;
    emit(SettingsLoaded(
      userState: await getUserState(),
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

  Future<void> setPhoneNumberState(String State) async {
    phoneNumberState = State;
    emit(SettingsLoaded(
      userState: await getUserState(),
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

  Future<void> setEmailState(String State) async {
    emailState = State;
    emit(SettingsLoaded(
      userState: await getUserState(),
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

  Future<void> setBioState(String State) async {
    bioState = State;
    emit(SettingsLoaded(
      userState: await getUserState(),
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

  // Update user field (generic update function for each field)
  Future<Map<String, dynamic>> updateField(
      String newValue, String field) async {
    Map<String, dynamic> response = await updateUserField(field, newValue);

    bool success = response['success'] ?? false;
    String message = response['success'] ? "Updated" : response['message'];

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

      emit(SettingsLoaded(
        userState: await getUserState(),
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

    return {'success': success, 'message': message};
  }

  Future<void> updateProfilePic(String blobname) async {
    String response = await generatePresignedUrl(blobname);
    final userState = (state as SettingsLoaded).userState;
    userState?.copyWith(profilePic: response);

    emit(SettingsLoaded(
      userState: await getUserState(),
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

  Future<Map<String, dynamic>> sendCode(
      String email, BuildContext context) async {
    Map<String, dynamic> response =
        await sendConfirmationCodeEmail(email, context);
    bool success = response['success'] ?? false;
    String message = response['message'] == null ? "" : response['message'];

    emit(SettingsLoaded(
      userState: await getUserState(),
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
    return {'success': success, 'message': message};
  }

  Future<Map<String, dynamic>> verifyCode(
      String code, String email, BuildContext context) async {
    Map<String, dynamic> response = await verifyEmailCode(code, email, context);
    print(
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahhhhhhhhhhhhhhhhhhhhhhhh");

    bool success = response['success'] ?? false;
    String message = response['message'];
    if (success) {
      final userState = (state as SettingsLoaded).userState;
      userState?.copyWith(email: email);
    }
    emit(SettingsLoaded(
      userState: await getUserState(),
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
    return {'success': success, 'message': message};
  }

  // // Set update flags
  // void setUpdateFlags({
  //   bool? isNameUpdatedFlag,
  //   bool? isUsernameUpdatedFlag,
  //   bool? isPhoneUpdatedFlag,
  //   bool? isEmailUpdatedFlag,
  //   bool? isBioUpdatedFlag,
  // }) {
  //   if (isNameUpdatedFlag != null) isNameUpdated = isNameUpdatedFlag;
  //   if (isUsernameUpdatedFlag != null)
  //     isUsernameUpdated = isUsernameUpdatedFlag;
  //   if (isPhoneUpdatedFlag != null) isPhoneUpdated = isPhoneUpdatedFlag;
  //   if (isEmailUpdatedFlag != null) isEmailUpdated = isEmailUpdatedFlag;
  //   if (isBioUpdatedFlag != null) isBioUpdated = isBioUpdatedFlag;

  //   if (state is SettingsLoaded) {
  //     emitSettingsLoaded(
  //       userState: (state as SettingsLoaded).userState!,
  //       isEditing: isEditing,
  //       isNameUpdated: isNameUpdated,
  //       isUsernameUpdated: isUsernameUpdated,
  //       isPhoneUpdated: isPhoneUpdated,
  //       isEmailUpdated: isEmailUpdated,
  //       isBioUpdated: isBioUpdated,
  //       nameController: nameController,
  //       usernameController: usernameController,
  //       emailController: emailController,
  //       bioController: bioController,
  //       phoneController: phoneController,
  //     );
  //   }
  // }
}
