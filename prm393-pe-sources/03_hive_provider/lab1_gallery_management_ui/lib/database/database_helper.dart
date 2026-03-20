import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/artwork.dart';
import '../models/favorite.dart';
import 'dart:convert';

/// Helper class to manage Hive box operations.
class HiveHelper {
  static const String userBoxName = 'users';
  static const String artworkBoxName = 'artworks';
  static const String favoriteBoxName = 'favorites';

  /// Initializes Hive and opens all required boxes.
  static Future<void> initHive() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ArtworkAdapter());
    Hive.registerAdapter(FavoriteAdapter());

    // Open Boxes
    await Hive.openBox<User>(userBoxName);
    await Hive.openBox<Artwork>(artworkBoxName);
    await Hive.openBox<Favorite>(favoriteBoxName);

    // Initial Seeding if empty
    await seedData();
  }

  /// Seeds initial data into the Hive boxes if the User box is empty.
  static Future<void> seedData() async {
    var userBox = Hive.box<User>(userBoxName);
    var artBox = Hive.box<Artwork>(artworkBoxName);
    var favBox = Hive.box<Favorite>(favoriteBoxName);

    if (userBox.isEmpty) {
      print("Seeding Hive boxes with mock data...");
      final data = json.decode(mooc_data);

      // Seed Users
      for (var u in data['users']) {
        final user = User.fromMap(u);
        // Simulate auto-increment ID
        user.id = userBox.length + 1;
        await userBox.add(user);
      }

      // Seed Artworks
      for (var a in data['artworks']) {
        final art = Artwork.fromMap(a);
        art.id = artBox.length + 1;
        await artBox.add(art);
      }

      // Seed Favorites
      for (var f in data['favorites']) {
        final fav = Favorite.fromMap(f);
        fav.id = favBox.length + 1;
        await favBox.add(fav);
      }
      print("Hive seeding completed successfully.");
    }
  }

  static String mooc_data = '''
  {
    "users": [
      {
        "username": "admin",
        "email": "admin@gmail.com",
        "password": "123456",
        "createdAt": "2024-01-01"
      }
    ],
    "artworks": [
      {
        "title": "Sunset Landscape",
        "artist": "John Doe",
        "year": "2020",
        "category": "Landscape",
        "description": "Beautiful sunset view",
        "createdBy": 1
      },
      {
        "title": "Abstract Dream",
        "artist": "Anna Smith",
        "year": "2022",
        "category": "Abstract",
        "description": "Colorful abstract painting",
        "createdBy": 1
      },
      {
        "title": "Portrait Lady",
        "artist": "Leonardo",
        "year": "2019",
        "category": "Portrait",
        "description": "Classic portrait",
        "createdBy": 1
      },
      {
        "title": "Thanh",
        "artist": "Leonardo",
        "year": "2019",
        "category": "Portrait",
        "description": "Classic portrait",
        "createdBy": 1
      },
      {
        "title": "Vui",
        "artist": "Leonardo",
        "year": "2019",
        "category": "Portrait",
        "description": "Classic portrait",
        "createdBy": 1
      }
    ],
    "favorites": [
      {
        "userId": 1,
        "artworkId": 1,
        "createdAt": "2024-01-02"
      }
    ]
  }''';
}
