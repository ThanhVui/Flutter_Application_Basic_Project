import 'product.dart';

class Order {
  final int id;
  final String date;
  final double total;
  final List<Product>? products;

  Order({
    required this.id,
    required this.date,
    required this.total,
    this.products,
  });

  factory Order.fromMap(Map<String, dynamic> map, {List<Product>? items}) {
    return Order(
      id: map['id'],
      date: map['date'],
      total: map['total'],
      products: items,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date,
    'total': total,
  };
}
