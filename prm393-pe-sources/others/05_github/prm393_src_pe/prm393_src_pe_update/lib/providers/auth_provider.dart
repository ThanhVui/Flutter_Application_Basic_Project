import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    final user = await _repo.login(email, password);
    if (user != null) {
      state = state.copyWith(user: user, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false, error: "Invalid credentials (email or password incorrect)");
    }
  }

  Future<bool> register(String email, String password, String fullName, String phone) async {
    state = state.copyWith(isLoading: true, error: null);
    final success = await _repo.register(email, password, fullName, phone);
    state = state.copyWith(isLoading: false);
    if (!success) {
      state = state.copyWith(error: "Registration failed (email might already exist)");
    }
    return success;
  }

  Future<void> checkSession() async {
    state = state.copyWith(isLoading: true);
    final user = await _repo.checkSession();
    state = state.copyWith(user: user, isLoading: false);
  }

  Future<void> logout() async {
    await _repo.logout();
    state = AuthState();
  }
}
