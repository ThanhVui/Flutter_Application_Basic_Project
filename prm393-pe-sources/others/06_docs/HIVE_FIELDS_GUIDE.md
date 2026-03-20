# Hướng dẫn thay đổi trường dữ liệu trong Hive

Tài liệu này hướng dẫn cách thêm/sửa/xóa các trường (fields) trong các model khi sử dụng Hive.

---

## Danh mục

1. [Cấu trúc Model](#1-cấu-trúc-model)
2. [Thêm trường mới](#2-thêm-trường-mới)
3. [Sửa đổi trường hiện có](#3-sửa-đổi-trường-hiện-có)
4. [Xóa trường](#4-xóa-trường)
5. [Chạy lại code generation](#5-chạy-lại-code-generation)
6. [Cập nhật DatabaseService](#6-cập-nhật-databaseservice)

---

## 1. Cấu trúc Model

### Product Model (`lib/models/product.dart`)

```dart
import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String image;

  @HiveField(6)
  bool isFavorite;
  // ...
}
```

### User Model (`lib/models/user.dart`)

```dart
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String password;

  @HiveField(3)
  final String? email;
  // ...
}
```

---

## 2. Thêm trường mới

### Bước 1: Thêm trường vào Model

**Ví dụ:** Thêm trường `rating` (double) vào Product

**File:** `lib/models/product.dart`

```dart
@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String image;

  @HiveField(6)
  bool isFavorite;

  // 👇 THÊM MỚI: trường rating
  @HiveField(7)
  double rating;

  // 👇 THÊM MỚI: cập nhật constructor
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.isFavorite = false,
    this.rating = 0.0, // thêm giá trị mặc định
  });

  // 👇 THÊM MỚI: cập nhật toJson()
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'isFavorite': isFavorite,
      'rating': rating, // thêm
    };
  }

  // 👇 THÊM MỚI: cập nhật copyWith()
  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image,
    bool? isFavorite,
    double? rating, // thêm
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating, // thêm
    );
  }
}
```

### Bước 2: Chạy lại code generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 3. Sửa đổi trường hiện có

### Thay đổi kiểu dữ liệu

**Ví dụ:** Thay đổi `price` từ `double` sang `int`

**File:** `lib/models/product.dart`

```dart
// TRƯỚC
@HiveField(2)
final double price;

// SAU
@HiveField(2)
final int price;
```

**Lưu ý:** Khi thay đổi kiểu dữ liệu:
1. Cập nhật constructor
2. Cập nhật `toJson()` và `copyWith()`
3. Chạy lại code generation

### Thay đổi tên trường

**Ví dụ:** Thay đổi `title` thành `name`

**File:** `lib/models/product.dart`

```dart
// TRƯỚC
@HiveField(1)
final String title;

// SAU (vẫn giữ @HiveField(1) để giữ dữ liệu cũ)
@HiveField(1)
final String name;
```

Sau đó cập nhật các method sử dụng `title`:

```dart
// Trong constructor, toJson, copyWith...
name: json['name'] ?? json['title'], // đọc cả key cũ và mới
```

---

## 4. Xóa trường

### Bước 1: Xóa trường khỏi Model

**Ví dụ:** Xóa trường `image` khỏi Product

**File:** `lib/models/product.dart`

```dart
// XÓA những dòng này:
@HiveField(5)
final String image;

// Và trong constructor, toJson, copyWith...
```

### Bước 2: Chạy lại code generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Bước 3 (Quan trọng): Xóa dữ liệu cũ

Vì Hive lưu trữ dữ liệu theo binary, khi xóa trường, dữ liệu cũ vẫn còn trong storage. Để xóa:

**File:** `lib/services/database_service.dart`

```dart
Future<void> init() async {
  // ...phần mở box...

  // THÊM: Xóa database cũ nếu cần (trong quá trình development)
  // await _productsBox.clear(); // ⚠️ Chỉ dùng khi cần reset dữ liệu
}
```

**Hoặc** có thể xóa app trên thiết bị và chạy lại.

---

## 5. Chạy lại Code Generation

Sau mỗi lần thay đổi model, chạy:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Kiểm tra file generated đã được cập nhật:

- `lib/models/product.g.dart`
- `lib/models/user.g.dart`

---

## 6. Cập nhật DatabaseService

### Khi thêm dữ liệu mẫu (seed data)

**File:** `lib/services/database_service.dart`

```dart
Future<void> _seedProducts() async {
  final mockData = [
    Product(
      id: 1,
      title: 'Smartphone',
      price: 699.99,
      description: 'A high-end smartphone...',
      category: 'electronics',
      image: '',
      isFavorite: false,
      rating: 4.5, // 👈 Thêm trường mới vào seed data
    ),
    // ...
  ];
}
```

### Khi thay đổi cấu trúc Box

Nếu thay đổi typeId hoặc thêm box mới:

```dart
static const String productsBoxName = 'products';
static const String usersBoxName = 'users';
// Thêm box mới nếu cần
static const String settingsBoxName = 'settings';
```

```dart
// Trong init()
late Box<Product> _productsBox;
late Box<User> _usersBox;
late Box<Settings> _settingsBox; // Thêm nếu cần
```

---

## Tóm tắt các file cần thay đổi

| Thay đổi | Files cần sửa |
|----------|---------------|
| Thêm/sửa/xóa trường model | `lib/models/product.dart` hoặc `lib/models/user.dart` |
| Chạy code generation | Terminal: `flutter pub run build_runner build --delete-conflicting-outputs` |
| Cập nhật seed data | `lib/services/database_service.dart` (hàm `_seedProducts()`, `_seedUsers()`) |
| Thêm box mới | `lib/services/database_service.dart` (biến `Box`, hàm `init()`) |
| Cập nhật UI hiển thị | Các screen files: `lib/screens/*.dart` |
| Cập nhật business logic | Các provider files: `lib/providers/*.dart` |

---

## Lưu ý quan trọng

1. **Không thay đổi @HiveField(id)** nếu muốn giữ dữ liệu cũ
2. **TypeId phải là duy nhất** trong ứng dụng (Product = 0, User = 1)
3. **Luôn chạy build_runner** sau khi thay đổi model
4. **Giá trị mặc định** nên được cung cấp trong constructor để tránh lỗi
