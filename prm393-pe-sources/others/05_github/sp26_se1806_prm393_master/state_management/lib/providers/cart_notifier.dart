import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:state_management/models/product.dart';

/***************** MANUAL ***********************/
// class CartNotifier extends Notifier<List<Product>> {
//   // Initial value
//   @override
//   List<Product> build() {
//     return [
//       Product(id: 1, name: 'T-Shirt', price: 80),
//       Product(id: 2, name: 'Hat', price: 180),
//       Product(id: 3, name: 'Robe', price: 200),
//     ];
//   }
//
//   // Nếu cần những p/thức khác thay đổi state
//   // Khai báo tiếp tục
//
//   // addToCart
//   // removeFromCart
//   // clearCart
// }
//
// final cartNotifierProvider = NotifierProvider<CartNotifier, List<Product>>(() {
//   return CartNotifier();
// });

/****************** build_runner ******************/
part 'cart_notifier.g.dart';

@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  // init stae
  @override
  List<Product> build() {
    print('build() called');
    return [
      Product(id: 1, name: 'T-Shirt', price: 80),
      Product(id: 2, name: 'Hat', price: 180),
      Product(id: 3, name: 'Robe', price: 200),
    ];
  }
  // các p/thức khác
  void addItem(Product product) {
    print('Adding product #${product.id}');
    print('Before: state has ${state.length} items');
    //state.add(product); // State được QL theo reference -> add element vao state vẫn state cũ
    state = [...state, product]; // Proper practice
    print('After: state has ${state.length} items');
  }
  void removeItem() {
  }
  void clearItem() {
    state = [];
  }
}
// Lưu ý:
// 1. Annotation `@riverpod` báo cho generator biết đây là provider sẽ được gen
// 2. _$CartNotifier -> short của NotifierProvider....
// 3. part (báo cho biết 1 phần code nằm ở file khac)
// 4. Naming convention
//    Tên class (CartNotifier) -> bỏ suffix Notifier -> thêm suffix Provider
//        CartNotifier                    Cart                  cartProvider


// Provider dependency
// Cần  1 provider -> doc vào cartProvider trả về số item
@riverpod
int totalItems(ref) {
  return ref.watch(cartProvider).length;
}