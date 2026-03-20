import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/database_service.dart';

class ProductProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<Product> _products = [];
  List<Product> _favorites = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Product> get favorites => _favorites;
  List<Product> get filteredProducts => _filteredProducts;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _dbService.getProducts();
      _favorites = _products.where((p) => p.isFavorite).toList();
      _filteredProducts = List.from(_products);
      _categories = await _dbService.getAllCategories();
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> syncFavorites() async {
    await fetchProducts();
  }

  // Search products by title or description
  Future<void> searchProducts(String query) async {
    _searchQuery = query;
    await _applyFilters();
  }

  // Filter products by category
  Future<void> filterByCategory(String category) async {
    _selectedCategory = category;
    await _applyFilters();
  }

  // Apply both search and category filters
  Future<void> _applyFilters() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Product> result = _products;

      // Apply category filter
      if (_selectedCategory != 'All') {
        result = result
            .where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase())
            .toList();
      }

      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        final lowerQuery = _searchQuery.toLowerCase();
        result = result
            .where((p) =>
                p.title.toLowerCase().contains(lowerQuery) ||
                p.description.toLowerCase().contains(lowerQuery))
            .toList();
      }

      _filteredProducts = result;
    } catch (e) {
      debugPrint('Error applying filters: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Clear all filters
  Future<void> clearFilters() async {
    _searchQuery = '';
    _selectedCategory = 'All';
    _filteredProducts = List.from(_products);
    notifyListeners();
  }

  // Update a product
  Future<void> updateProduct(Product product) async {
    try {
      await _dbService.updateProduct(product);
      await fetchProducts();
    } catch (e) {
      debugPrint('Update Product error: $e');
    }
  }

  Future<void> toggleFavorite(Product product) async {
    try {
      product.isFavorite = !product.isFavorite;
      await _dbService.updateProduct(product);
      await fetchProducts();
    } catch (e) {
      debugPrint('Toggle Favorite error: $e');
      product.isFavorite = !product.isFavorite;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _dbService.insertProduct(product);
      await fetchProducts();
    } catch (e) {
      debugPrint('Add Product error: $e');
      _products.insert(0, product);
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _dbService.deleteProduct(id);
      await fetchProducts();
    } catch (e) {
      debugPrint('Delete Product error: $e');
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
    }
  }
}
