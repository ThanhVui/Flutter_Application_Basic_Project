import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/database_service.dart';

class ProductProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<Product> _products = [];
  List<Product> _favorites = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Product> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _dbService.getProducts();
      _favorites = _products.where((p) => p.isFavorite).toList();
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> syncFavorites() async {
    // With database-only logic, syncFavorites just refreshes the list from DB
    await fetchProducts();
  }

  Future<void> toggleFavorite(Product product) async {
    try {
      product.isFavorite = !product.isFavorite;
      await _dbService.updateProduct(product);
      await fetchProducts(); // Refresh lists
    } catch (e) {
      debugPrint('Toggle Favorite error: $e');
      // On web fallback
      product.isFavorite = !product.isFavorite;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _dbService.insertProduct(product);
      await fetchProducts(); // Refresh list to include new product
    } catch (e) {
      debugPrint('Add Product error: $e');
      _products.insert(0, product);
      notifyListeners();
    }
  }
}
