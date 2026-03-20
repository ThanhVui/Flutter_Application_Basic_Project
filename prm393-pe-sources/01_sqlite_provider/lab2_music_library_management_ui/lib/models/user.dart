/// Model class representing a in the application.
class User {
  int? id;
  String username;
  String email;
  String password;
  String createdAt;

  /// Standard constructor to initialize an object.
  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  /// Converts an object into a Map structure.
  /// This is used when inserting or updating data in the SQLite database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'createdAt': createdAt,
    };
  }

  /// Factory constructor to restore an object from a database Map.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      createdAt: map['createdAt'],
    );
  }
}
