import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/models/product.dart';
import 'package:state_management/providers/cart_notifier.dart';
import 'package:state_management/providers/user_provider.dart';

// Đổi lớp Cha StatelessWidget -> ConsumerWidget
class HomeStlss extends ConsumerWidget {
  const HomeStlss({super.key});

  @override // trong p/thức build: thêm 1 param là WidgetRef ref
  Widget build(BuildContext context, WidgetRef ref) {
    // Dùng ref để gọi userProvider (lấy state)
    final users = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Task'), backgroundColor: Colors.blueAccent),
      body: ListView(
        children: users.map((u) {
          return ListTile(
            trailing: Icon(Icons.edit),
            title: Text(u.name),
            subtitle: Text(u.email),
          );
        }).toList(),
      ),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product list'),
        backgroundColor: Colors.blueAccent,
        actions: [
          // Go to cart
          IconButton(
            onPressed: () {
              // Nav to Cart Detail screen
              Navigator.pushNamed(context, '/cart_details');
            },
            icon: Badge(
              label: Text('${ref.watch(totalItemsProvider)}'),
              child: Icon(Icons.shopping_cart),
            ), // Badge
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(10, (index) {
          return Card(
            child: Column(
              children: [
                Text('Product ${index + 1}'),
                IconButton(
                  onPressed: () {
                    // Goi phương thức addItem trong cartNotifier
                    ref
                        .read(cartProvider.notifier)
                        .addItem(
                          Product(
                            id: index + 1,
                            name: 'Product ${index + 1}',
                            price: 50,
                          ),
                        );
                  },
                  icon: Icon(Icons.add_shopping_cart),
                ),
              ],
            ),
          );
        }),
      ),
      // bottomNavigationBar: BottomNavigationBar(items: [
      //   BottomNavigationBarItem(icon: icon)
      // ]),
    );
  }
}
