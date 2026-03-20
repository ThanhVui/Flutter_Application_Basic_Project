import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../repositories/auth_repository.dart';
import '../repositories/product_repository.dart';
import 'auth_provider.dart';
import 'product_provider.dart';
import 'cart_provider.dart';
import 'order_provider.dart';
import 'theme_provider.dart';

export 'theme_provider.dart'; 

// Services
final apiServiceProvider = Provider((ref) => ApiService());
final localStorageServiceProvider = Provider((ref) => LocalStorageService());

// Repositories
final authRepositoryProvider = Provider((ref) {
  final local = ref.watch(localStorageServiceProvider);
  return AuthRepository(local);
});

final productRepositoryProvider = Provider((ref) {
  final api = ref.watch(apiServiceProvider);
  final local = ref.watch(localStorageServiceProvider);
  return ProductRepository(api, local);
});

// Providers
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});

final productStateProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return ProductNotifier(repo);
});

final cartStateProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

final orderStateProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  final local = ref.watch(localStorageServiceProvider);
  return OrderNotifier(local);
});
