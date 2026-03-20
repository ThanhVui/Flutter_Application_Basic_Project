# 🚀 Flutter & Dart: Comprehensive Study Guide (PRM393)

This guide synthesizes key knowledge for Flutter development, focusing on Dart, UI components, state management, and local storage (SQLite, Hive, SharedPreferences) as required by the **PRM393** syllabus.

---

## 🎯 1. Dart Essentials (The Foundation)

### 🔹 Type System & Null Safety
Dart is a type-safe language. Modern Dart uses **Sound Null Safety**.
- `String? name`: Can be a string or null.
- `String name`: Cannot be null.
- `late String description`: Promised to be initialized before use.
- `name ?? 'Default'`: If `name` is null, use 'Default'.
- `name?.length`: Safe call (returns null if `name` is null).

### 🔹 Collections
- **List:** `List<int> numbers = [1, 2, 3];`
- **Set:** `Set<String> unique = {'a', 'b'};`
- **Map:** `Map<String, int> scores = {'Alice': 10};`

### 🔹 Asynchronous Programming
Essential for network calls and database operations.
- **Future:** Represents a value that will be available later.
- **async/await:** Makes async code look synchronous.
- **Stream:** A sequence of asynchronous events.

```dart
Future<void> fetchData() async {
  try {
    var data = await api.getData();
    print(data);
  } catch (e) {
    print('Error: $e');
  }
}
```

---

## 🏗️ 2. Flutter UI & Architecture

### 🔹 Widget Tree & Lifecycle
Everything in Flutter is a Widget.
- **StatelessWidget:** Needs no internal state (immutable).
- **StatefulWidget:** Has internal state that can change (`setState`).

**StatefulWidget Lifecycle:**
1. `createState()`
2. `initState()` - One-time setup.
3. `didChangeDependencies()`
4. `build()` - Called every time UI needs update.
5. `dispose()` - Clean up resources (controllers, timers).

### 🔹 Core Widgets
- **Layout:** `Scaffold`, `AppBar`, `Container`, `Row`, `Column`, `Stack`, `SizedBox`.
- **Lists:** `ListView.builder` (efficient for long lists), `GridView`.
- **Input:** `TextField`, `TextFormField` (with validation), `Form`.

### 🔹 Navigation (Navigator 1.0)
```dart
// Push to new screen
Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen()));

// Pop (Back)
Navigator.pop(context);

// Named Routes (defined in MaterialApp)
Navigator.pushNamed(context, '/details', arguments: data);
```

---

## 💾 3. Local Storage (The Big Three)

| Feature | **SharedPreferences** | **SQLite** | **Hive** |
| :--- | :--- | :--- | :--- |
| **Type** | Key-Value Pairs | Relational (SQL) | NoSQL (Binary) |
| **Best For** | User settings, simple flags. | Complex queries, large data. | High-perf, offline caching. |
| **Speed** | Slow (Disk access) | Moderate | Very Fast |
| **Schema** | None | Rigid (SQL Schema) | Semi-structured |

### 🛠️ SharedPreferences
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setBool('isLoggedIn', true); // Save
bool? isLogged = prefs.getBool('isLoggedIn'); // Read
```

### 🛠️ SQLite (sqflite)
SQLite is a relational database. It is best for structured data and complex queries.

**Data Types:**
- `INTEGER`: Whole numbers.
- `REAL`: Floating point numbers.
- `TEXT`: Strings.
- `BLOB`: Binary data (images, files).
- `NULL`: Null values.
*(Note: Use `INTEGER` (0/1) for Booleans and `TEXT` or `INTEGER` for Dates).*

**CRUD Operations:**
```dart
// 1. Create (Insert)
await db.insert('users', {'id': 1, 'name': 'John'}, conflictAlgorithm: ConflictAlgorithm.replace);

// 2. Read (Query)
List<Map<String, dynamic>> maps = await db.query('users');
// Or with filter:
List<Map<String, dynamic>> results = await db.query('users', where: 'id = ?', whereArgs: [1]);

// 3. Update
await db.update('users', {'name': 'Jane'}, where: 'id = ?', whereArgs: [1]);

// 4. Delete
await db.delete('users', where: 'id = ?', whereArgs: [1]);
```

### 🛠️ Hive
Hive is a NoSQL, lightweight, and blazing-fast key-value database.

**Data Types:**
- Supports all primitive types: `String`, `int`, `double`, `bool`, `List`, `Map`.
- Supports custom objects via **TypeAdapters** (requires code generation).

**CRUD Operations:**
```dart
// Opening a Box
var box = await Hive.openBox('myBox');

// 1. Create / Update (Put)
box.put('username', 'antigravity'); // Creates if not exists, else updates
box.add('some value'); // Auto-incrementing key

// 2. Read (Get)
String name = box.get('username', defaultValue: 'Guest');
var firstItem = box.getAt(0); // Access by index

// 3. Delete
box.delete('username');
box.deleteAt(0);
```

---

## 🔋 4. State Management

### 🔹 Ephemeral State (Local)
Managed using `setState()` inside a `StatefulWidget`. Best for state that doesn't leave the widget (e.g., current page index, animation values).

### 🔹 App State (Global)
Managed for data shared across multiple screens (e.g., Auth, Cart).
- **Provider:** The most recommended "simple" way.
- **Riverpod:** A more robust, compile-safe version of Provider.
- **BLoC:** Uses Streams for complex business logic.

---

## 🌐 5. Networking & JSON

### 🔹 HTTP Request
Using the `http` package:
```dart
final response = await http.get(Uri.parse('https://api.example.com/items'));
if (response.statusCode == 200) {
  var data = jsonDecode(response.body);
  // Convert to Model objects
}
```

### 🔹 Model Class Pattern
Always convert JSON to a Dart Object for type safety.
```dart
class User {
  final String id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name']);
  }
}
```

---

## 📝 6. Exam Tips (PRM393 Focus)

1.  **Hot Reload vs Hot Restart:** Reload updates code and keeps state; Restart resets the app state.
2.  **Constraints Flow Down:** Parents set constraints (min/max size), Children set their size within those, Parents set children's positions.
3.  **FutureBuilder & StreamBuilder:** Use them for clean UI handling of async data.
4.  **Dispose Controllers:** Always call `dispose()` for `TextEditingController` or `AnimationController` to avoid memory leaks.
5.  **Main Function:** The entry point is `void main() => runApp(MyApp());`.

---
*Created by Antigravity for PRM393 Students.*
