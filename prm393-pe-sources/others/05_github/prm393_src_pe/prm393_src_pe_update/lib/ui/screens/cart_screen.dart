import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../models/product.dart';
import '../../models/order.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Shopping Cart')),
      body: cart.items.isEmpty
          ? const Center(child: Text("Cart is empty."))
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items.values.toList()[index];
                return ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(item.product.image)),
                  title: Text(item.product.title),
                  subtitle: Text("${item.quantity} x \$${item.product.price}"),
                  trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), 
                    onPressed: () => ref.read(cartStateProvider.notifier).removeItem(item.product.id!)),
                );
              },
            ),
      bottomNavigationBar: Container(
        height: 100,
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total: \$${cart.totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: cart.items.isEmpty ? null : () async {
                final order = Order(
                  id: DateTime.now().millisecondsSinceEpoch,
                  date: DateTime.now().toString(),
                  total: cart.totalAmount,
                );
                
                final dbItems = cart.items.values.map((e) => {
                  'productId': e.product.id,
                  'quantity': e.quantity,
                }).toList();

                await ref.read(orderStateProvider.notifier).placeOrder(order, dbItems);
                ref.read(cartStateProvider.notifier).clear();
                
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Order Success!")));
                Navigator.pop(context);
              },
              child: const Text("Place Order"),
            )
          ],
        ),
      ),
    );
  }
}
