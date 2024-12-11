class UserView {
  final int id;
  final String userName;
  final String profilePic;
  final bool liked;

  UserView({
    required this.id,
    required this.userName,
    required this.profilePic,
    required this.liked,
  });

  factory UserView.fromJson(Map<String, dynamic> json) {
    return UserView(
      id: json['id'],
      userName: json['userName'],
      profilePic: json['profilePic'],
      liked: json['liked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'profilePic': profilePic,
      'liked': liked,
    };
  }

  UserView copyWith({
    int? id,
    String? userName,
    String? profilePic,
    bool? liked,
  }) {
    return UserView(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      profilePic: profilePic ?? this.profilePic,
      liked: liked ?? this.liked,
    );
  }
}
