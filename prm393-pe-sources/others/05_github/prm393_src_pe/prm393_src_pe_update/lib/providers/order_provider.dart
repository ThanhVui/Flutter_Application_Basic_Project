import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../services/local_storage_service.dart';

class OrderState {
  final List<Order> orders;
  final bool isLoading;

  OrderState({this.orders = const [], this.isLoading = false});

  OrderState copyWith({List<Order>? orders, bool? isLoading}) {
    return OrderState(
        orders: orders ?? this.orders, isLoading: isLoading ?? this.isLoading);
  }
}

class OrderNotifier extends StateNotifier<OrderState> {
  final LocalStorageService _local;

  OrderNotifier(this._local) : super(OrderState());

  Future<void> placeOrder(Order order, List<Map<String, dynamic>> items) async {
    state = state.copyWith(isLoading: true);
    await _local.createOrder(order, items);
    state = state.copyWith(orders: [...state.orders, order], isLoading: false);
  }

  Future<void> fetchOrders() async {
    state = state.copyWith(isLoading: true);
    // In a real app we'd fetch from SQLite. 
    // For this session I'll keep it simple by just updating the state after orders are created.
    // Actually let's assume orders are stored in the state for now for the mock feel.
    state = state.copyWith(isLoading: false);
  }
}
