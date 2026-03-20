

/// Database service to handle Authentication processes.
/// This includes creating new users and verifying credentials.
class AuthService {
  /// Login: Verifies if a user exists with the provided credentials.
  /// Uses hard-coded credentials: admin / 123456.
  /// Returns a Map with id and username if successful, otherwise null.
  Future<Map<String, dynamic>?> login(String username, String password) async {
    // HARD-CODED CHECK
    if (username == "admin" && password == "123456") {
      return {
        'id': 1,
        'username': 'admin',
      };
    }

    return null; // Authentication failed
  }
}

