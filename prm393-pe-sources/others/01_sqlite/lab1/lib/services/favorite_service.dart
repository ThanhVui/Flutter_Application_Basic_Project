import '../database/database_helper.dart';
import '../models/favorite.dart';
import '../models/artwork.dart';

class FavoriteService {
  final dbHelper = DBHelper();

  // ADD FAVORITE (NO DUPLICATE)
  Future<String?> addFavorite(Favorite fav) async {
    final db = await dbHelper.database;

    var existing = await db.query(
      'favorites',
      where: 'userId = ? AND artworkId = ?',
      whereArgs: [fav.userId, fav.artworkId],
    );

    if (existing.isNotEmpty) {
      return "Already in favorites";
    }

    await db.insert('favorites', fav.toMap());
    return null;
  }

  // GET FAVORITES (Mapped to Artworks)
  Future<List<Artwork>> getFavorites(int userId) async {
    final db = await dbHelper.database;

    final result = await db.rawQuery('''
      SELECT artworks.* FROM artworks
      INNER JOIN favorites 
      ON artworks.id = favorites.artworkId
      WHERE favorites.userId = ?
    ''', [userId]);

    return result.map((e) => Artwork.fromMap(e)).toList();
  }

  // CHECK IF FAVORITE
  Future<bool> isFavorite(int userId, int artworkId) async {
    final db = await dbHelper.database;
    var result = await db.query(
      'favorites',
      where: 'userId = ? AND artworkId = ?',
      whereArgs: [userId, artworkId],
    );
    return result.isNotEmpty;
  }

  // REMOVE
  Future<int> removeFavorite(int userId, int artworkId) async {
    final db = await dbHelper.database;

    return await db.delete(
      'favorites',
      where: 'userId = ? AND artworkId = ?',
      whereArgs: [userId, artworkId],
    );
  }

  // COUNT
  Future<int> countFavorites(int userId) async {
    final db = await dbHelper.database;

    var result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM favorites WHERE userId = ?',
      [userId],
    );

    return result.first['count'] as int;
  }
}