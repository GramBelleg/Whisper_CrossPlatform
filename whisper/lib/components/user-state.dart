import 'package:equatable/equatable.dart';
import 'package:whisper/services/shared-preferences.dart';
import 'package:whisper/services/update-user-field.dart';

class UserState extends Equatable {
  final String name;
  final String username;
  final String email;
  final String bio;
  final String profilePic;
  final String lastSeen;
  final String status;
  final String phoneNumber;
  final int autoDownloadSize;
  final String lastSeenPrivacy;
  final String pfpPrivacy;
  final bool readReceipts;

  UserState({
    required this.name,
    required this.username,
    required this.email,
    required this.bio,
    required this.profilePic,
    required this.lastSeen,
    required this.status,
    required this.phoneNumber,
    required this.autoDownloadSize,
    required this.lastSeenPrivacy,
    required this.pfpPrivacy,
    required this.readReceipts,
  });

  // CopyWith method
  Future<UserState> copyWith({
    String? name,
    String? username,
    String? email,
    String? bio,
    String? profilePic,
    String? lastSeen,
    String? status,
    String? phoneNumber,
    int? autoDownloadSize,
    String? lastSeenPrivacy,
    String? pfpPrivacy,
    bool? readReceipts,
  }) async {
    final updatedUserState = UserState(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profilePic: profilePic ?? this.profilePic,
      lastSeen: lastSeen ?? this.lastSeen,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      autoDownloadSize: autoDownloadSize ?? this.autoDownloadSize,
      lastSeenPrivacy: lastSeenPrivacy ?? this.lastSeenPrivacy,
      pfpPrivacy: pfpPrivacy ?? this.pfpPrivacy,
      readReceipts: readReceipts ?? this.readReceipts,
    );

    await saveUserState(updatedUserState); // Save the updated state
    return updatedUserState; // Return updated UserState
  }

  // From JSON method
  factory UserState.fromJson(Map<String, dynamic> json) {
    return UserState(
      name: json['name'] as String,
      username: json['userName'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String,
      profilePic: json['profilePic'] as String,
      lastSeen: json['lastSeen'] as String,
      status: json['status'] as String,
      phoneNumber: json['phoneNumber'] as String,
      autoDownloadSize: json['autoDownloadSize'] as int,
      lastSeenPrivacy: json['lastSeenPrivacy'] as String,
      pfpPrivacy: json['pfpPrivacy'] as String,
      readReceipts: json['readReceipts'] as bool,
    );
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'userName': username,
      'email': email,
      'bio': bio,
      'profilePic': profilePic,
      'lastSeen': lastSeen,
      'status': status,
      'phoneNumber': phoneNumber,
      'autoDownloadSize': autoDownloadSize,
      'lastSeenPrivacy': lastSeenPrivacy,
      'pfpPrivacy': pfpPrivacy,
      'readReceipts': readReceipts,
    };
  }

  @override
  List<Object?> get props => [
        name,
        username,
        email,
        bio,
        profilePic,
        lastSeen,
        status,
        phoneNumber,
        autoDownloadSize,
        lastSeenPrivacy,
        pfpPrivacy,
        readReceipts,
      ];

  // Method to update user name
  Future<UserState?> updateName(String newName) async {
    if (await updateUserField('name', newName)) {
      return await copyWith(
          name: newName); // Call copyWith to save and return updated UserState
    }
    return null; // Indicate failure
  }

  // Method to update user username
  Future<UserState?> updateUsername(String newUsername) async {
    if (await updateUserField('username', newUsername)) {
      return await copyWith(
          username:
              newUsername); // Call copyWith to save and return updated UserState
    }
    return null; // Indicate failure
  }

  // Method to update user phone number
  Future<UserState?> updatePhoneNumber(String newPhoneNumber) async {
    if (await updateUserField('phoneNumber', newPhoneNumber)) {
      return await copyWith(
          phoneNumber:
              newPhoneNumber); // Call copyWith to save and return updated UserState
    }
    return null; // Indicate failure
  }

  // Method to update user email
  Future<UserState?> updateEmail(String newEmail) async {
    if (await updateUserField('email', newEmail)) {
      return await copyWith(
          email:
              newEmail); // Call copyWith to save and return updated UserState
    }
    return null; // Indicate failure
  }

  // Method to update user bio
  Future<UserState?> updateBio(String newBio) async {
    if (await updateUserField('bio', newBio)) {
      return await copyWith(
          bio: newBio); // Call copyWith to save and return updated UserState
    }
    return null; // Indicate failure
  }

  // Method to update user profile picture
  Future<UserState?> updateProfilePic(String newProfilePic) async {
    if (await updateUserField('profilePic', newProfilePic)) {
      return await copyWith(
          profilePic:
              newProfilePic); // Call copyWith to save and return updated UserState
    }
    return null; // Indicate failure
  }
}
