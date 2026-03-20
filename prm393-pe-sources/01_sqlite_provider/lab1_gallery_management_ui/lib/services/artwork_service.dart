import '../database/database_helper.dart';
import '../models/artwork.dart';

/// Service class to handle data-access operations for Artworks.
/// Bridges the communication between providers and the database.
class ArtworkService {
  final dbHelper = DBHelper();

  /// Create: Inserts a new Artwork entry into the SQLite 'artworks' table.
  Future<int> insertArtwork(Artwork artwork) async {
    final db = await dbHelper.database;
    // Converts the Dart [Artwork] object into a Map for the SQL engine
    return await db.insert('artworks', artwork.toMap());
  }

  /// Read: Fetches all artworks created by a specific user from the database.
  Future<List<Artwork>> getArtworks(int userId) async {
    final db = await dbHelper.database;

    // Queried artworks based on the 'createdBy' user ID filter
    final result = await db.query(
      'artworks',
      where: 'createdBy = ?',
      whereArgs: [userId],
    );

    // Map each row in the query result back into a structured Artwork object
    return result.map((e) => Artwork.fromMap(e)).toList();
  }

  /// Update: Modifies existing artwork details in the SQLite database based on its ID.
  Future<int> updateArtwork(Artwork artwork) async {
    final db = await dbHelper.database;

    return await db.update(
      'artworks',
      artwork.toMap(),
      where: 'id = ?',
      whereArgs: [artwork.id],
    );
  }

  /// Delete: Removes an artwork entry from the database using its primary key [id].
  Future<int> deleteArtwork(int id) async {
    final db = await dbHelper.database;

    return await db.delete(
      'artworks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Search: Finds artworks by Title using SQL 'LIKE' pattern matching for a specific user.
  Future<List<Artwork>> searchArtworks(String keyword, int userId) async {
    final db = await dbHelper.database;

    final result = await db.query(
      'artworks',
      where: 'title LIKE ? AND createdBy = ?', // Case-insensitive title search
      whereArgs: ['%$keyword%', userId],
    );

    return result.map((e) => Artwork.fromMap(e)).toList();
  }
}