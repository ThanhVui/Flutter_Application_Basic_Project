# PE Sample - Store Inventory Application
flutter emulators --launch Pixel_3a_XL
## Giới Thiệu

Project Flutter demo với các chức năng quản lý sản phẩm cơ bản (CRUD), xác thực người dùng và giao diện responsive.

## Tính Năng

| Tính năng | Mô tả |
|------------|-------|
| Đăng nhập | Xác thực username/password |
| Danh sách sản phẩm | Hiển thị sản phẩm dạng List (mobile) hoặc Grid (tablet) |
| Chi tiết sản phẩm | Xem thông tin chi tiết sản phẩm |
| Thêm sản phẩm | Form thêm sản phẩm mới với validation |
| Yêu thích | Toggle sản phẩm yêu thích |
| Thông báo | Push notification khi thêm sản phẩm |
| Responsive | Tự động điều chỉnh giao diện theo kích thước màn hình |

## Thông Tin Đăng Nhập (Test)

```
Username: admin
Password: password123
```

## Cấu Trúc Project

```
lib/
├── main.dart                      # Entry point
├── models/
│   ├── user.dart                 # Model User
│   └── product.dart              # Model Product
├── providers/
│   ├── auth_provider.dart        # Xử lý auth
│   └── product_provider.dart    # Xử lý sản phẩm
├── screens/
│   ├── login_screen.dart         # Màn hình login
│   ├── home_screen.dart          # Màn hình chính
│   ├── product_detail_screen.dart# Chi tiết sản phẩm
│   └── product_form_screen.dart  # Thêm sản phẩm
├── services/
│   ├── database_service.dart     # Database
│   ├── storage_service.dart      # Local storage
│   └── notification_service.dart # Notifications
└── theme/
    └── app_theme.dart            # Theme config
```

## Cách Chạy

```bash
# Cài đặt dependencies
flutter pub get

# Chạy app
flutter run
```

## Hướng Dẫn Chỉnh Sửa

### Thay đổi thông tin đăng nhập

**File:** `lib/providers/auth_provider.dart` (dòng 34)

```dart
if (username == 'admin' && password == 'password123') {
// Thay 'admin' và 'password123' thành giá trị mới
```

### Thay đổi tiêu đề App

**File:** `lib/main.dart` (dòng 36)

```dart
title: 'Flutter CLO Showcase',
```

### Thay đổi danh mục sản phẩm

**File:** `lib/screens/product_form_screen.dart` (dòng 21-26)

```dart
final List<String> _categories = [
  'electronics',
  'jewelery',
  "men's clothing",
  "women's clothing"
];
// Thêm/xóa category tại đây
```

### Thay đổi Theme

**File:** `lib/theme/app_theme.dart`
- Chỉnh sửa `lightTheme` cho giao diện sáng
- Chỉnh sửa `darkTheme` cho giao diện tối

## Yêu Cầu Môi Trường

- Flutter 3.x trở lên
- Android SDK
- Java 17+
- Xcode (nếu chạy trên iOS)

## Công Nghệ Sử Dụng

- **State Management:** Provider
- **Local Storage:** SharedPreferences
- **Database:** SQLite (sqflite)
- **Notifications:** flutter_local_notifications
- **HTTP:** http package (cho API)

## License

MIT License

Thêm trường year vào Product
Tầng	File	Thay đổi
1. Model	lib/models/product.dart	Thêm int year
2. Database	lib/services/database_service.dart	Thêm year INTEGER vào schema và seed data
3. Form	lib/screens/product_form_screen.dart	Thêm TextField nhập year
4. Detail	lib/screens/product_detail_screen.dart	Hiển thị year
5. Home	lib/screens/home_screen.dart	Hiển thị year (nếu cần)
Chi tiết từng file:
1. Model (lib/models/product.dart):

// Thêm vào constructor và properties
final int year;
// Trong factory Product.fromJson
year: json['year'],
// Trong toJson
'year': year,
// Trong fromMap  
year: map['year'],
2. Database (lib/services/database_service.dart):

// Schema: thêm year INTEGER
'CREATE TABLE products(id INTEGER PRIMARY KEY, title TEXT, price REAL, description TEXT, category TEXT, image TEXT, isFavorite INTEGER, year INTEGER)'
// Seed data: thêm 'year': 2024 vào mỗi record
3. Form (lib/screens/product_form_screen.dart):

// Thêm controller
final _yearController = TextEditingController();
// Thêm field
TextFormField(
  controller: _yearController,
  decoration: const InputDecoration(labelText: 'Year'),
  keyboardType: TextInputType.number,
)
// Trong submit(): thêm year: int.parse(_yearController.text)

The user wants me to read the product_detail_screen.dart file, which I've already done. Let me continue with the detailed instructions for modifying this file to add the year field.
4. Detail Screen - lib/screens/product_detail_screen.dart
Thêm hiển thị year (dòng 41, sau price):

// SAU dòng hiển thị price
Text(
  '\$${product.price.toStringAsFixed(2)}',
  style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
),
const SizedBox(height: 10),
// 👇 THÊM MỚI
Text(
  'Year: ${product.year}',
  style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Colors.grey[600],
      ),
),
const SizedBox(height: 20),
5. Home Screen - lib/screens/home_screen.dart
The user wants to add the year field to home_screen.dart. Looking at the code, there are two widgets that display product info: 1. `_buildProductCard` (line 104-132) - shows in GridView 2. `_buildProductTile` (line 134-153) - shows in ListView
For the card (line 127):

Text('\$${product.price.toStringAsFixed(2)}'),
For the tile (line 143):

subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
I should add year display to both. Let me provide the specific code changes.

5. Home Screen - lib/screens/home_screen.dart
Cần sửa 2 vị trí hiển thị:

a) Trong _buildProductCard (dòng 127, sau price):

// TRƯỚC
Text('\$${product.price.toStringAsFixed(2)}'),
// SAU
Text('\$${product.price.toStringAsFixed(2)}'),
const SizedBox(height: 4),
Text(
  'Year: ${product.year}',
  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
),
b) Trong _buildProductTile (dòng 143, subtitle):

// TRƯỚC
subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
// SAU
subtitle: Text('\$${product.price.toStringAsFixed(2)} • Year: ${product.year}'),
Tóm tắt tất cả các vị trí cần sửa:
File	Dòng	Nội dung
lib/models/product.dart	8	Thêm final int year;
lib/models/product.dart	17	Thêm required this.year
lib/models/product.dart	28	Thêm year: json['year']
lib/models/product.dart	41	Thêm 'year': year
lib/models/product.dart	55	Thêm year: map['year']
lib/services/database_service.dart	32	Schema: thêm year INTEGER
lib/services/database_service.dart	44-72	Seed data: thêm year
lib/services/database_service.dart	28	Đổi version: 2
lib/screens/product_form_screen.dart	18	Thêm _yearController
lib/screens/product_form_screen.dart	33	Thêm _yearController.dispose()
lib/screens/product_form_screen.dart	45	Thêm year: int.parse(_yearController.text)
lib/screens/product_form_screen.dart	108	Thêm TextFormField cho year
lib/screens/product_detail_screen.dart	41	Thêm hiển thị year
lib/screens/home_screen.dart	127	Thêm hiển thị year trong card
lib/screens/home_screen.dart	143	Thêm hiển thị year trong tile
