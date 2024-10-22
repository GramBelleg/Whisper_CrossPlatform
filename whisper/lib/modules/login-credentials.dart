class LoginCredentials {
  final String? email;
  final String? password;

  LoginCredentials({
    this.email,
    this.password,
  });

  // Method to convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory LoginCredentials.fromMap(Map<String, dynamic> map) {
    return LoginCredentials(email: map['email'], password: map['password']);
  }
}
