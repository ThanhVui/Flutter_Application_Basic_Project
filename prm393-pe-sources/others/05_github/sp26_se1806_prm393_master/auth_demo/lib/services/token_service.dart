import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class TokenService {
  final SharedPreferences prefs; // thuộc tính = instance SF
  TokenService(this.prefs); // Constructor

  // saveToken
  // User -> luu accessToken & refreshToken vao shared prefs (local storage)
  Future<void> saveToken(User user) async {
    // Shared preferences provider -> save tokens
    await prefs.setString("accessToken", user.accessToken);
    await prefs.setString("refreshToken", user.refreshToken);
    await prefs.setInt("userId", user.id);
    await prefs.setString("username", user.username);
    await prefs.setString("email", user.email);
  }

  // getToken
  // doc tu shared prefs (LS), cac thong tin da luu (accessToken/refreshToken)
  Future<User?> getToken() async {
    final accessToken = await prefs.getString("accessToken");
    final refreshToken = await prefs.getString("refreshToken");
    final id = await prefs.getInt("userId");
    final username = await prefs.getString("username");
    final email = await prefs.getString("email");

    if (accessToken != null && refreshToken != null) {
      return User(
        accessToken: accessToken,
        refreshToken: refreshToken,
        id: id!,
        username: username!,
        email: email!,
      );
    } else {
      return null;
    }
  }

  // clearToken
  // Xoa token (logout)
  Future<void> clearToken() async {
    await prefs.remove("accessToken");
    await prefs.remove("refreshToken");
  }
}
