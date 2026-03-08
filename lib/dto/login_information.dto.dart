class LoginInformation {
  const LoginInformation({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  factory LoginInformation.fromJson(Map<String, dynamic> json) {
    return LoginInformation(
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
