class User {
  final String email;
  final String password;
  final String phone;

  User({
    required this.email,
    required this.password,
    required this.phone,
  });

  // Method to convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'phone': phone,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
    );
  }
}
