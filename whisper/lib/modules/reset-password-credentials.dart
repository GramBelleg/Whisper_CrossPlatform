class ResetPasswordCredentials {
  final String? code;
  final String? password;
  final String? confirmPassword;
  String? email;

  ResetPasswordCredentials({
    this.code,
    this.confirmPassword,
    this.password,
    this.email,
  });

  // Method to convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'password': password,
      'confirmPassword': confirmPassword,
      'code': code,
      'email': email,
    };
  }

  factory ResetPasswordCredentials.fromMap(Map<String, dynamic> map) {
    return ResetPasswordCredentials(
      code: map['code'],
      password: map['password'],
      confirmPassword: map['confirmPassword'],
      email: map['email'],
    );
  }
}
