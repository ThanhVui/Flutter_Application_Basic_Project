import 'package:flutter/material.dart';
import '../services/artwork_service.dart';
import '../models/artwork.dart';

/// Provider for managing artworks logic and state.
/// It interacts with ArtworkService to fetch, add, update, and delete artworks.
class ArtworkProvider extends ChangeNotifier {
  final ArtworkService _service = ArtworkService();
  
  // List to store current artworks for the UI
  List<Artwork> _artworks = [];
  bool _isLoading = false;

  // Getters to access the state
  List<Artwork> get artworks => _artworks;
  bool get isLoading => _isLoading;
  int get totalArtworks => _artworks.length;

  /// Fetches all artworks from the database for a specific user ID.
  /// Updates [isLoading] state to show a loading spinner on the UI.
  Future<void> loadArtworks(int userId) async {
    _isLoading = true;
    notifyListeners();
    _artworks = await _service.getArtworks(userId);
    _isLoading = false;
    notifyListeners();
  }

  /// Adds a new artwork to the database.
  /// Re-loads the artwork list after a successful insert to sync the UI.
  Future<void> addArtwork(Artwork artwork) async {
    await _service.insertArtwork(artwork);
    if (artwork.createdBy != null) {
      await loadArtworks(artwork.createdBy!);
    }
  }

  /// Updates an existing artwork's details.
  /// Matches the artwork by its [id] and updates all fields.
  Future<void> updateArtwork(Artwork artwork) async {
    await _service.updateArtwork(artwork);
    if (artwork.createdBy != null) {
      await loadArtworks(artwork.createdBy!);
    }
  }

  /// Deletes an artwork from the database using its ID.
  /// Automatically refreshes the UI list after deletion.
  Future<void> deleteArtwork(int id, int userId) async {
    await _service.deleteArtwork(id);
    await loadArtworks(userId);
  }

  /// Searches artworks by title.
  /// Real-time search by updating the [_artworks] list as the user types.
  Future<void> search(String keyword, int userId) async {
    _artworks = await _service.searchArtworks(keyword, userId);
    notifyListeners();
  }

  /// Filters artworks based on category and creation year.
  /// Logic: Filters the [all] artworks list locally instead of hitting the DB every time.
  void filter(String category, String year, int userId) async {
    List<Artwork> all = await _service.getArtworks(userId);
    
    _artworks = all.where((e) {
      // Logic for filtering category (matches if "All" or match exact type)
      bool catMatch = category == "All" || e.category == category;
      
      // Logic for filtering by year (matches if "All" or within last 5 years)
      bool yearMatch = year == "All";
      if (year == "Last 5 years") {
        int current = DateTime.now().year;
        yearMatch = int.tryParse(e.year) != null && current - int.parse(e.year) <= 5;
      }
      
      return catMatch && yearMatch;
    }).toList();
    
    notifyListeners(); // Refresh the list view in UI
  }
}
