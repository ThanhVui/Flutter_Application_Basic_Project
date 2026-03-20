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

  /// Task 2: Session Management - Checks if a valid user session exists in local storage.
  /// This is called when the app starts to auto-login the user.
  Future<void> checkSession() async {
    _userId = await SessionManager.getUser(); // Task 2: Check session storage
    _username = await SessionManager.getUsername();
    notifyListeners();
  }

  /// Task 1: Login (Hard-coded) - Authenticates the user with a username and password.
  /// If successful, saves the session locally (Task 2) and updates the app state.
  Future<String?> login(String username, String password) async {
    // Task 1: Login - Compare check happens inside AuthService.login
    Map<String, dynamic>? userMap = await _authService.login(username, password);
    
    if (userMap != null) {
      _userId = userMap['id'];
      _username = userMap['username'];

      // Task 2: Session Management - Save login session to SharedPreferences
      await SessionManager.saveUser(_userId!, _username!);

      notifyListeners();
      return null;
    }
    // Task 1: Login - Failure message
    return "Invalid username or password";
  }

  /// Task 3: Logout - Logs the user out by clearing local session data and resetting the state.
  Future<void> logout() async {
    // Task 3: Logout - Clear session data from local storage
    await SessionManager.clearSession();
    _userId = null;
    _username = null;
    notifyListeners();
  }
}

