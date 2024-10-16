class User {
  final String email;
  final String password;
  final String phoneNumber;

  User({
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  // Method to convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phone_number'],
    );
  }
}
