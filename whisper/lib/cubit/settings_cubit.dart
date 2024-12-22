import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:whisper/components/helpers.dart';
import 'package:whisper/controllers/custom_phone_controller.dart';
import 'package:whisper/models/user_state.dart';
import 'package:whisper/services/fetch_user_info.dart';
import 'package:whisper/services/send_confirmation_code_email.dart';
import 'package:whisper/services/verify_email_code.dart';
import 'package:whisper/services/read_file.dart';
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
  late CustomPhoneController phoneController;
  late UserState myUser;
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
        phoneController = CustomPhoneController(),
        emailController = TextEditingController(),
        bioController = TextEditingController(),
        super(SettingsLoading());

  // Helper method to update the state
  void _emitUpdatedState() async {
    emit(SettingsLoaded(
        userState: myUser,
        isEditing: isEditing,
        nameController: nameController,
        usernameController: usernameController,
        emailController: emailController,
        bioController: bioController,
        phoneController: phoneController,
        nameState: myUser.name,
        usernameState: myUser.username,
        emailState: myUser.email,
        phoneNumberState: myUser.phoneNumber,
        bioState: myUser.bio,
        nameStateUpdate: nameStateUpdate,
        usernameStateUpdate: usernameStateUpdate,
        emailStateUpdate: emailStateUpdate,
        phoneNumberStateUpdate: phoneNumberStateUpdate,
        bioStateUpdate: bioStateUpdate,
        profilePicState: myUser.profilePic,
        hasStory: myUser.hasStory));
  }

  Future<void> receiveMyProfilePic(String? blobName) async {
    String imageUrl = blobName != null
        ? await generatePresignedUrl(blobName)
        : 'https://ui-avatars.com/api/?background=0a122f&size=100&color=fff&name=${formatName(usernameState)}';
    print("changed Profile Pic");
    myUser = myUser.copyWith(profilePic: imageUrl);
    _emitUpdatedState();
  }

  void sendProfilePhoto(String blobName, {bool toRemove = false}) {
    if (!toRemove) {
      print("send my photo");

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
      myUser = (await fetchUserInfo())!;
      _populateControllers(myUser);
      _emitUpdatedState();
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
    _populateControllers(myUser);
    _emitUpdatedState();
  }

  Future<void> updateHasStoryUserState() async {
    if (!myUser.hasStory) {
      //remove if condition after update backend this
      myUser = myUser.copyWith(hasStory: !myUser.hasStory);
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
    print("the phone is uu $newValue");

    final response = await updateUserField(field, newValue);
    final success = response['success'] ?? false;
    final message = response['success'] ? "Updated" : response['message'];
    print("the phone is uu $response");
    if (success) {
      if (field == 'name') {
        myUser = myUser.copyWith(name: newValue);
      } else if (field == 'userName') {
        myUser = myUser.copyWith(username: newValue);
      } else if (field == 'phoneNumber') {
        myUser = myUser.copyWith(phoneNumber: newValue);
      } else if (field == 'bio') {
        myUser = myUser.copyWith(bio: newValue);
        print("bio aaa ${myUser.toJson()}");
      }
      _emitUpdatedState();
    }

    return {'success': success, 'message': message};
  }

  Future<void> updateProfilePic(String blobName) async {
    String response = await generatePresignedUrl(blobName);
    myUser = myUser.copyWith(profilePic: response);
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
      myUser = myUser.copyWith(email: email);
      _emitUpdatedState();
    }
    return response;
  }
}
