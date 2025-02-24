class AuthDataWithUserName {
  String username;
  String password;

  AuthDataWithUserName({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}