class ForwardedFrom {
  final int id;
  final String userName;
  final String? profilePic;

  ForwardedFrom({
    required this.id,
    required this.userName,
    this.profilePic,
  });

  factory ForwardedFrom.fromJson(Map<String, dynamic> json) {
    return ForwardedFrom(
      id: json['id'],
      userName: json['userName'],
      profilePic: json['profilePic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'profilePic': profilePic,
    };
  }

  @override
  String toString() {
    return 'ForwardedFrom(id: $id, userName: $userName, profilePic: ${profilePic ?? "null"})';
  }
}
