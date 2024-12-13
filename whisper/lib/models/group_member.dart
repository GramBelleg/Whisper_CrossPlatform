class GroupMember {
  final int id;
  final String userName;
  final String? profilePic;
  final bool isAdmin;
  final bool hasStory;
  final DateTime lastSeen;

  GroupMember({
    required this.id,
    required this.userName,
    required this.profilePic,
    required this.isAdmin,
    required this.hasStory,
    required this.lastSeen,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      id: json['id'],
      userName: json['userName'],
      profilePic: json['profilePic'],
      isAdmin: json['isAdmin'],
      hasStory: json['hasStory'],
      lastSeen: DateTime.parse(json['lastSeen']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'profilePic': profilePic,
      'isAdmin': isAdmin,
      'hasStory': hasStory,
      'lastSeen': lastSeen.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'GroupMember('
        'id: $id, '
        'userName: $userName, '
        'profilePic: $profilePic, '
        'isAdmin: $isAdmin, '
        'hasStory: $hasStory, '
        'lastSeen: $lastSeen'
        ')';
  }
}
