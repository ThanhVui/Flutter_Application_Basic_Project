import 'package:auth_demo/services/auth_service.dart';
import 'package:auth_demo/services/token_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'providers.g.dart';

// shared preferences provider = sẽ cung cấp 1 object SharedPreferences
@riverpod
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError();
}

// token service provider = cung cấp object tokenService (có 1 thuộc tính prefs -> DI vào)
final tokenServiceProvider = Provider<TokenService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return TokenService(prefs); // DI
});

// auth service provider = cung cap object authService (DI)
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});