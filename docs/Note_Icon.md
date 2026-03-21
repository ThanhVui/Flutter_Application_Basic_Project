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
Đang kiểm tra code hiện tại để xem cách thêm trường "artist" vào view.

Đang kiểm tra favorites_screen.dart để xem cách hiển thị:

Để thêm trường "artist" vào view, cần sửa 2 file:

1. Sửa home_screen.dart
a) Sửa _buildProductTile (dòng 299-332) — ListView
Hiện tại:

subtitle: Text(product.year.toString()),
Sửa thành:

subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(product.artist),  // Thêm dòng artist
    Text(product.year.toString()),
  ],
),
b) Sửa _buildProductCard (dòng 251-297) — GridView
Sau dòng 272 (sau Text title), thêm:

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8.0),
  child: Text(
    product.artist,
    style: TextStyle(
      fontSize: 12,
      color: Colors.grey[600],
    ),
  ),
),
2. Sửa favorites_screen.dart
a) Sửa _buildProductTile (dòng 142-173)
Hiện tại:

subtitle: Text('\$${product.year.toStringAsFixed(2)}'),
Sửa thành:

subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(product.artist),  // Thêm dòng artist
    Text('\$${product.year.toStringAsFixed(2)}'),
  ],
),
b) Sửa _buildProductCard (dòng 78-140)
Sau dòng 107 (sau Text title), thêm:

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8.0),
  child: Text(
    product.artist,
    style: TextStyle(
      fontSize: 12,
      color: Colors.grey[600],
    ),
  ),
),
Tóm tắt
ListView: dùng Column trong subtitle để hiển thị artist và year.
GridView: thêm một Text widget hiển thị artist sau title.
Lưu ý: Model Product đã có trường artist, nên chỉ cần sửa UI để hiển thị.

Bạn muốn tôi cung cấp code đầy đủ cho từng phương thức không?
Now I can see the product_detail_screen.dart. Currently it shows: - Line 28-33: Title - Line 35-42: Year (shown as price with green color) - Line 44-52: Description
To add artist, I need to add a new Text widget showing the artist field. I can add it after the title or after the year.

Sửa product_detail_screen.dart
Trong file này, hiện tại có title và year (hiển thị như giá). Để thêm artist, thêm widget mới.

Thêm sau dòng 42 (sau year, trước Description)
const SizedBox(height: 10),
Row(
  children: [
    const Icon(Icons.person, color: Colors.grey),
    const SizedBox(width: 8),
    Text(
      product.artist,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Colors.grey[700],
      ),
    ),
  ],
),
Code đầy đủ phần cần sửa (dòng 27-53)
children: [
  Text(
    product.title,
    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.bold,
    ),
  ),
  const SizedBox(height: 10),
  Text(
    (product.year.toString()),
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
      color: Colors.green,
      fontWeight: FontWeight.bold,
    ),
  ),
  // ========== THÊM ĐOẠN NÀY ==========
  const SizedBox(height: 10),
  Row(
    children: [
      const Icon(Icons.person, color: Colors.grey),
      const SizedBox(width: 8),
      Text(
        product.artist,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.grey[700],
        ),
      ),
    ],
  ),
  // ========== KẾT THÚC ==========
  const SizedBox(height: 20),
  const Text(
    'Description',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
  const SizedBox(height: 10),
  Text(
    product.description,
    style: const TextStyle(fontSize: 16, height: 1.5),
  ),
Kết quả hiển thị

Tiêu đề (Title)
2024                        ← Year (màu xanh lá)
👤 Vincent van Gogh         ← Artist (màu xám, có icon người)
Description
[text mô tả...]
Người dùng hỏi về danh sách các icon phổ biến nhất trong Flutter. Tôi sẽ cung cấp danh sách các Material Icons được sử dụng phổ biến nhất.
Danh sách Icon phổ biến nhất trong Flutter (Material Icons)
Navigation
Icon	Tên	Sử dụng
Icons.home	Home	Trang chủ
Icons.menu	Menu	Menu/Drawer
Icons.arrow_back	Back	Quay lại
Icons.arrow_forward	Forward	Đi tiếp
Icons.close	Close	Đóng
Icons.more_vert	More	Tùy chọn thêm
Action
Icon	Tên	Sử dụng
Icons.search	Search	Tìm kiếm
Icons.edit	Edit	Sửa
Icons.delete	Delete	Xóa
Icons.add	Add	Thêm
Icons.share	Share	Chia sẻ
Icons.settings	Settings	Cài đặt
Icons.refresh	Refresh	Làm mới
Social & User
Icon	Tên	Sử dụng
Icons.person	Person	Người dùng
Icons.group	Group	Nhóm
Icons.favorite / Icons.favorite_border	Favorite	Yêu thích
Icons.star / Icons.star_border	Star	Đánh giá
Icons.chat	Chat	Tin nhắn
Icons.email	Email	Email
Media
Icon	Tên	Sử dụng
Icons.image	Image	Hình ảnh
Icons.photo_camera	Camera	Chụp ảnh
Icons.play_arrow	Play	Phát
Icons.pause	Pause	Tạm dừng
Icons.music_note	Music	Nhạc
Icons.video_library	Video	Video
Communication
Icon	Tên	Sử dụng
Icons.phone	Phone	Điện thoại
Icons.message	Message	Tin nhắn
Icons.send	Send	Gửi
Icons.notifications	Notifications	Thông báo
Shopping & Commerce
Icon	Tên	Sử dụng
Icons.shopping_cart	Cart	Giỏ hàng
Icons.shopping_bag	Bag	Túi mua sắm
Icons.payment	Payment	Thanh toán
Icons.attach_money	Money	Tiền
Status
Icon	Tên	Sử dụng
Icons.check	Check	Hoàn thành
Icons.error	Error	Lỗi
Icons.warning	Warning	Cảnh báo
Icons.info	Info	Thông tin
Icons.lock	Lock	Khóa
Icons.visibility	Visibility	Hiển thị
File & Storage
Icon	Tên	Sử dụng
Icons.folder	Folder	Thư mục
Icons.insert_drive_file	File	File
Icons.download	Download	Tải về
Icons.upload	Upload	Tải lên
Icons.cloud	Cloud	Đám mây
Cách sử dụng:

Icon(Icons.person)           // Icon đơn thuần
Icon(Icons.person, size: 24) // Icon với kích thước tùy chỉnh
Icon(Icons.person, color: Colors.red) // Icon với màu tùy chỉnh
Icon Hình Vẽ / Hội Họa (Flutter Material Icons)
Brush & Paint
Icon	Tên	Sử dụng
Icons.brush	Brush	Cọ vẽ
Icons.palette	Palette	Bảng màu
Icons.format_paint	Format Paint	Tô màu
Icons.color_lens	Color Lens	Ống kính màu
Icons.colorize	Colorize	Tô màu
Art & Creative
Icon	Tên	Sử dụng
Icons.auto_fix_high	Auto Fix	Chỉnh sửa
Icons.draw	Draw	Vẽ tay
Icons.edit	Edit	Chỉnh sửa
Icons.create	Create	Tạo mới
Icons.gesture	Gesture	Nghệ thuật cử chỉ
Image & Gallery
Icon	Tên	Sử dụng
Icons.image	Image	Hình ảnh
Icons.photo	Photo	Ảnh
Icons.photo_library	Photo Library	Thư viện ảnh
Icons.collections	Collections	Bộ sưu tập
Icons.grid_view	Grid View	Lưới ảnh
Icons.wallpaper	Wallpaper	Hình nền
Frame & Canvas
Icon	Tên	Sử dụng
Icons.crop	Crop	Cắt ảnh
Icons.filter	Filter	Bộ lọc
Icons.auto_awesome	Auto Awesome	Hiệu ứng
Icons.texture	Texture	Kết cấu
Icons.style	Style	Phong cách
Suggested cho ứng dụng Art Gallery của bạn
// Trang Home - Banner hoặc Header
Icons.palette           // Bảng màu (logo/chủ đề)
Icons.brush             // Cọ vẽ
// Danh sách sản phẩm
Icons.image             // Hình ảnh tác phẩm
Icons.collections       // Bộ sưu tập
// Chi tiết sản phẩm
Icons.zoom_in           // Phóng to xem
Icons.info              // Thông tin tác phẩm
// Filter/Danh mục
Icons.filter            // Lọc theo thể loại
Icons.category          // Danh mục