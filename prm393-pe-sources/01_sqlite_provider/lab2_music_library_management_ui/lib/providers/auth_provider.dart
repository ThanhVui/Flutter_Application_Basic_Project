import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/session_manager.dart';

/// Provider class to manage the Authentication state of the application.
/// It handles login, logout, and session persistence.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // Internal state variables for the logged-in user
  int? _userId;
  String? _username;

  // Public getters to access the user state from the UI
  int? get userId => _userId;
  String? get username => _username;
  bool get isLoggedIn => _userId != null;

  /// Checks if a valid user session exists in local storage.
  /// This is called when the app starts to auto-login the user.
  Future<void> checkSession() async {
    _userId = await SessionManager.getUser();
    _username = await SessionManager.getUsername();
    notifyListeners(); // Refresh UI based on session status
  }

  /// Authenticates the user with a username and password.
  /// If successful, saves the session locally and updates the app state.
  Future<String?> login(String username, String password) async {
    Map<String, dynamic>? userMap = await _authService.login(username, password);
    
    if (userMap != null) {
      _userId = userMap['id'];
      _username = userMap['username'];

      // Persist the user session to SharedPreferences
      await SessionManager.saveUser(_userId!, _username!);

      notifyListeners(); // Notify all listening widgets (like HomeScreen)
      return null; // Null indicates success
    }
    return "Invalid username or password";
  }

  /// Logs the user out by clearing local session data and resetting the state.
  Future<void> logout() async {
    await SessionManager.clearSession(); // Remove from local storage
    _userId = null;
    _username = null;
    notifyListeners(); // Navigate user back to LoginScreen
  }
}

