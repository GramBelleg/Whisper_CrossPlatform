class Sender {
  final int? id;
  final String userName;
  final String? profilePic;

  Sender({
    this.id,
    required this.userName,
    this.profilePic,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
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
}
