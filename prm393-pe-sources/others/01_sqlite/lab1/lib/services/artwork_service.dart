import '../database/database_helper.dart';
import '../models/artwork.dart';

class ArtworkService {
  final dbHelper = DBHelper();

  // CREATE
  Future<int> insertArtwork(Artwork artwork) async {
    final db = await dbHelper.database;
    return await db.insert('artworks', artwork.toMap());
  }

  // READ ALL
  Future<List<Artwork>> getArtworks(int userId) async {
    final db = await dbHelper.database;

    final result = await db.query(
      'artworks',
      where: 'createdBy = ?',
      whereArgs: [userId],
    );

    return result.map((e) => Artwork.fromMap(e)).toList();
  }

  // UPDATE
  Future<int> updateArtwork(Artwork artwork) async {
    final db = await dbHelper.database;

    return await db.update(
      'artworks',
      artwork.toMap(),
      where: 'id = ?',
      whereArgs: [artwork.id],
    );
  }

  // DELETE
  Future<int> deleteArtwork(int id) async {
    final db = await dbHelper.database;

    return await db.delete(
      'artworks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // SEARCH
  Future<List<Artwork>> searchArtworks(String keyword, int userId) async {
    final db = await dbHelper.database;

    final result = await db.query(
      'artworks',
      where: 'title LIKE ? AND createdBy = ?',
      whereArgs: ['%$keyword%', userId],
    );

    return result.map((e) => Artwork.fromMap(e)).toList();
  }
}