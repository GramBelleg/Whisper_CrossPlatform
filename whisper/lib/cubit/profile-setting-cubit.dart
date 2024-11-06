import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:whisper/components/user-state.dart';
import 'package:whisper/services/shared-preferences.dart'; // Your UserState model
import 'package:whisper/services/update-user-field.dart'; // Assuming this is where the update functions are defined

part 'profile-setting-state.dart'; // This connects to the state file

class SettingsCubit extends Cubit<SettingsState> {
  bool isEditing = false;

  SettingsCubit() : super(SettingsInitial());

  Future<void> loadUserState() async {
    try {
      UserState? userState = await getUserState(); // Fetch user state
      if (userState != null) {
        emit(SettingsLoaded(userState, isEditing: isEditing));
      } else {
        emit(SettingsLoadError("User state not found.")); // Handle null case
      }
    } catch (e) {
      emit(SettingsLoadError(
          "Error loading user state: $e")); // Handle exceptions
    }
  }

  void toggleEditing() {
    isEditing = !isEditing;
    if (state is SettingsLoaded) {
      emit(SettingsLoaded((state as SettingsLoaded).userState,
          isEditing: isEditing));
    }
  }

  void updateUserState(UserState? updatedUserState) {
    emit(SettingsLoaded(updatedUserState, isEditing: isEditing));
  }

  // API Method to update the user's name
  Future<bool> updateName(String newName) async {
    bool success = await updateUserField('name', newName);
    if (success) {
      (state as SettingsLoaded).userState?.copyWith(name: newName);
      emit(SettingsLoaded(await getUserState(),
          isEditing: isEditing)); // Update the state
    }
    return success;
  }

  // API Method to update the user's username
  Future<bool> updateUsername(String newUsername) async {
    bool success = await updateUserField('userName', newUsername);
    if (success) {
      (state as SettingsLoaded).userState?.copyWith(username: newUsername);
      emit(SettingsLoaded(await getUserState(),
          isEditing: isEditing)); // Update the state
    }
    return success;
  }

  // API Method to update the user's phone number
  Future<bool> updatePhoneNumber(String newPhoneNumber) async {
    bool success = await updateUserField('phoneNumber', newPhoneNumber);
    if (success) {
      (state as SettingsLoaded)
          .userState
          ?.copyWith(phoneNumber: newPhoneNumber);
      emit(SettingsLoaded(await getUserState(),
          isEditing: isEditing)); // Update the state
    }
    return success;
  }

  // API Method to send code the user's email
  Future<bool> sendEmailCode(String newEmail) async {
    bool success = await updateUserField('emailcode', newEmail);
    if (success) {
      (state as SettingsLoaded).userState?.copyWith(email: newEmail);
      emit(SettingsLoaded(await getUserState(),
          isEditing: isEditing)); // Update the state
    }
    return success;
  }

  // API Method to update the user's email
  Future<bool> UpdateEmail(String newEmail) async {
    bool success = await updateUserField('email', newEmail);
    if (success) {
      (state as SettingsLoaded).userState?.copyWith(email: newEmail);
      emit(SettingsLoaded(await getUserState(),
          isEditing: isEditing)); // Update the state
    }
    return success;
  }

  // API Method to update the user's bio
  Future<bool> updateBio(String newBio) async {
    bool success = await updateUserField('bio', newBio);
    if (success) {
      (state as SettingsLoaded).userState?.copyWith(bio: newBio);
      emit(SettingsLoaded(await getUserState(),
          isEditing: isEditing)); // Update the state
    }
    return success;
  }

  // API Method to update the user's profile picture
  Future<bool> updateProfilePic(String newProfilePic) async {
    bool success = await updateUserField('profilePic', newProfilePic);
    if (success) {
      (state as SettingsLoaded).userState?.copyWith(profilePic: newProfilePic);
      emit(SettingsLoaded(await getUserState(),
          isEditing: isEditing)); // Update the state
    }
    return success;
  }
}
