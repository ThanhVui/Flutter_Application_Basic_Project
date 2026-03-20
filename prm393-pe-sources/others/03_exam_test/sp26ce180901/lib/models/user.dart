class User {
  int id;
  String username;
  String email;
  String password;
  String createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'createdAt': createdAt
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['title'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      createdAt: json['createdAt']
    );
  }
}