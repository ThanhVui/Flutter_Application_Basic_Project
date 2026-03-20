import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:state_management/models/user.dart';

// File hiện tại (user_provider.dart) có 1 phần code
// nằm trong file 'user_provider.g.dart'
// Lưu ý naming convention tên file output (.g.dart)
// có phần đầu giống file hiện tại
part 'user_provider.g.dart';

List<User> allUsers = [
  User(id: 1, name: 'John', email: 'jon@mail.com'),
  User(id: 2, name: 'NVA', email: 'jon@mail.com'),
  User(id: 3, name: 'TBT', email: 'jon@mail.com'),
  User(id: 4, name: 'NBC', email: 'jon@mail.com'),
  User(id: 5, name: 'John2', email: 'jon@mail.com'),
  User(id: 6, name: 'John3', email: 'jon@mail.com'),
];

// Provider (cung cấp) các dự liệu user
// Manual
// final userProvider = Provider((ref){
//   return allUsers;
// });

// Dùng Riverpod Generator
// Naming convention -> generator lấy tên của fn + suffix Provider
// user(ref) ----> userProvider
@riverpod
List<User> user(ref) {
  return allUsers;
}

// Dùng lenh dart run build_runner build de build ra file user_provider.g.dart
