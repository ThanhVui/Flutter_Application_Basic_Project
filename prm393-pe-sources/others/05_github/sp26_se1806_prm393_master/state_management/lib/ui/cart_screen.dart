import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/providers/cart_notifier.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Number of items: 0'),
          ),
          ...cartItems.map((item) { // Spread operator
            return ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text(item.name),
              subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
            );
          })
        ],
      ),
    );
  }
}
