class User {
  int id;
  String accessToken;
  String refreshToken;
  String username;
  String email;

  User({
    required this.id,
    required this.accessToken,
    required this.refreshToken,
    required this.username,
    required this.email,
  });

  // toJSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    // named constructor
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
