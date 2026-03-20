import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});
}

class CartState {
  final Map<int, CartItem> items;
  final double totalAmount;

  CartState({this.items = const {}, this.totalAmount = 0.0});

  CartState copyWith({Map<int, CartItem>? items, double? totalAmount}) {
    return CartState(
        items: items ?? this.items, totalAmount: totalAmount ?? this.totalAmount);
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  // Changed to support custom quantity
  void addItem(Product product, int quantity) {
    var items = Map<int, CartItem>.from(state.items);
    if (items.containsKey(product.id)) {
      items.update(
        product.id!,
        (existing) => CartItem(product: existing.product, quantity: existing.quantity + quantity),
      );
    } else {
      items.putIfAbsent(product.id!, () => CartItem(product: product, quantity: quantity));
    }
    _updateTotal(items);
  }

  void removeItem(int id) {
    var items = Map<int, CartItem>.from(state.items);
    items.remove(id);
    _updateTotal(items);
  }

  void clear() {
    state = CartState();
  }

  void _updateTotal(Map<int, CartItem> items) {
    double total = 0.0;
    items.forEach((key, item) {
      total += item.product.price * item.quantity;
    });
    state = state.copyWith(items: items, totalAmount: total);
  }
}
