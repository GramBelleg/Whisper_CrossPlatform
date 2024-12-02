import 'package:equatable/equatable.dart';
import 'package:whisper/services/shared_preferences.dart';

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
  final bool hasStory;

  const UserState({
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
    required this.hasStory,
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
    bool? hasStory,
  }) async {
    // Create a new instance with the updated values or existing values if none are provided
    UserState updatedUserState = UserState(
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
      hasStory: hasStory ?? this.hasStory,
    );

    // Save the updated state after any changes
    await saveUserState(updatedUserState);

    return updatedUserState; // Return the updated UserState
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
      hasStory: json['hasStory'] as bool,
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
      'hasStory': hasStory,
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
        hasStory,
      ];
}
