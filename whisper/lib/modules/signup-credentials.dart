class SignupCredentials {
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? name;
  final String? userName;
  final String? confirmPassword;
  SignupCredentials({
    this.email,
    this.password,
    this.confirmPassword,
    this.phoneNumber,
    this.name,
    this.userName
  });

  // Method to convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'confirmPassword':confirmPassword,
      'name':name,
      'userName':userName
    };
  }

  factory SignupCredentials.fromMap(Map<String, dynamic> map) {
    return SignupCredentials(
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phone'],
    );
  }
}
