class SignupCredentials {
  String? email;
  String? password;
  String? phoneNumber;
  String? name;
  String? userName;
  String? confirmPassword;

  SignupCredentials(
      {this.email,
      this.password,
      this.confirmPassword,
      this.phoneNumber,
      this.name,
      this.userName});

  // Method to convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'confirmPassword': confirmPassword,
      'name': name,
      'userName': userName
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
