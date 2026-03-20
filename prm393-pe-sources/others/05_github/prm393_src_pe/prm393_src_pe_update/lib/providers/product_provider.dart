import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductState {
  final List<Product> products;
  final bool isLoading;
  final String? error;

  ProductState({this.products = const [], this.isLoading = false, this.error});

  ProductState copyWith({List<Product>? products, bool? isLoading, String? error}) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository _repo;

  ProductNotifier(this._repo) : super(ProductState());

  Future<void> fetchProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final products = await _repo.getProducts();
      state = state.copyWith(products: products, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Failed to fetch products: $e");
    }
  }

  Future<bool> addProduct(Product product) async {
    state = state.copyWith(isLoading: true);
    final res = await _repo.addProduct(product);
    state = state.copyWith(isLoading: false);
    if (res != null) {
      state = state.copyWith(products: [...state.products, res]);
      return true;
    }
    return false;
  }

  Future<bool> updateProduct(Product product) async {
    state = state.copyWith(isLoading: true);
    final res = await _repo.updateProduct(product);
    state = state.copyWith(isLoading: false);
    if (res != null) {
      state = state.copyWith(products: [
        for (var p in state.products) if (p.id == product.id) res else p
      ]);
      return true;
    }
    return false;
  }

  Future<bool> deleteProduct(int id) async {
    state = state.copyWith(isLoading: true);
    final success = await _repo.deleteProduct(id);
    state = state.copyWith(isLoading: false);
    if (success) {
      state = state.copyWith(products: [
        for (var p in state.products) if (p.id != id) p
      ]);
      return true;
    }
    return false;
  }
}
