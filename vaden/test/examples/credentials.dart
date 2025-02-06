class Credentials {
  final String email;
  final String password;

  Credentials({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  static Credentials fromJson(Map<String, dynamic> json) {
    return Credentials(
      email: json['email'],
      password: json['password'],
    );
  }
}
