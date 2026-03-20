# 🏗️ Database Connectivity & Management (PRM393 Cheat Sheet)

This guide covers everything you need to know about connecting to **SQLite** and **Hive**, creating structures, handling relationships, and inserting data for your PRM393 exam.

---

## 💎 1. SQLite (sqflite)

### 🔹 Connection & Initialization
Always use a **Singleton** pattern for the Database Helper to ensure only one connection exists.

```dart
class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        // REQUIRED: Enable foreign keys for relationships
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await createTables(db);
        await loadMockData(db); // Multiple ways to insert data
      },
    );
  }
}
```

### 🔹 Handling Relationships (1-1, 1-n, n-n)

#### 👫 1:1 Relationship (One-to-One)
*Logic: A User has exactly one Profile.*
```sql
CREATE TABLE profile (
  id INTEGER PRIMARY KEY,
  userId INTEGER UNIQUE, -- Unique constraint makes it 1:1
  bio TEXT,
  FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
)
```

#### 👨‍👩‍👧 1:n Relationship (One-to-Many)
*Logic: One User creates many Artworks.*
```sql
CREATE TABLE artworks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT,
  createdBy INTEGER, -- Foreign Key
  FOREIGN KEY (createdBy) REFERENCES users (id) ON DELETE CASCADE
)
```

#### 👯 n:n Relationship (Many-to-Many)
*Logic: An Artwork can be in many Categories; A Category can have many Artworks.*
```sql
-- Step 1: Create the Junction Table
CREATE TABLE artwork_categories (
  artworkId INTEGER,
  categoryId INTEGER,
  PRIMARY KEY (artworkId, categoryId),
  FOREIGN KEY (artworkId) REFERENCES artworks (id) ON DELETE CASCADE,
  FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE CASCADE
)
```

### 🔹 Inserting Mock Data (3 Methods)

1.  **Direct Map Injection:**
    ```dart
    await db.insert('users', {'username': 'admin', 'email': 'a@b.com'});
    ```
2.  **JSON String (Hardcoded in code):**
    ```dart
    String jsonStr = '{"users": [{"name": "A"}, {"name": "B"}]}';
    var data = json.decode(jsonStr);
    for (var item in data['users']) await db.insert('users', item);
    ```
3.  **JSON File (Assets):**
    ```dart
    // Must add assets/data.json to pubspec.yaml
    String jsonString = await rootBundle.loadString('assets/data.json');
    final data = json.decode(jsonString);
    // Iterate and insert...
    ```

---

## 🍯 2. Hive (NoSQL)

### 🔹 Connection & Setup
Hive is object-oriented and doesn't use SQL.

```dart
// main.dart
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter()); // Register custom models
  await Hive.openBox('userBox');
  runApp(MyApp());
}
```

### 🔹 Creating "Tables" (Model & Adapter)
```dart
@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late String name;
  
  @HiveField(1)
  HiveList<Artwork>? artworks; // 1:n relationship in Hive
}
```

### 🔹 Relationships in Hive
*   **1:n:** Use `HiveList` or store a list of keys (`List<int> artworkIds`).
*   **Manual Linking:** Store the `id` (key) of another object manually.

### 🔹 CRUD in Hive
```dart
var box = Hive.box('userBox');
box.put('key1', userObject); // Create/Update
var user = box.get('key1');  // Read
box.delete('key1');          // Delete
```

---

## ⚠️ 3. Critical Precautions (Exam Check)

### ✅ DO NOT FORGET:
1.  **Foreign Keys:** In SQLite, always run `PRAGMA foreign_keys = ON` in `onConfigure`. Otherwise, constraints won't work!
2.  **Context in `initState`:** Avoid calling database methods directly in `initState` if they need `context`. Use `Future.delayed` or `WidgetsBinding.instance.addPostFrameCallback`.
3.  **Async/Await:** Database calls are **Async**. Always use `await` or the app will crash or data will be empty.
4.  **Dispose Controllers:** Always call `dispose()` on `TextEditingController` after inserting data.
5.  **Data Types:** 
    *   Booleans in SQLite = `INTEGER` (0/1).
    *   Dates in SQLite = `TEXT` (ISO8601) or `INTEGER` (Timestamp).
6.  **Transaction:** When inserting large mock data, use a **Transaction** to make it 10x faster:
    ```dart
    await db.transaction((txn) async {
      for (var item in data) await txn.insert('table', item);
    });
    ```

---
*Created by Antigravity - PRM393 Expert*
