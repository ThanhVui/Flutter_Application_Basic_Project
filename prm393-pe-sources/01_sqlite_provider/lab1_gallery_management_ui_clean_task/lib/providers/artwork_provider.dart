import 'package:flutter/material.dart';
import '../services/artwork_service.dart';
import '../models/artwork.dart';

/// Provider for managing artworks logic and state.
/// It interacts with [ArtworkService] to handle core CRUD operations and filtering.
class ArtworkProvider extends ChangeNotifier {
  final ArtworkService _service = ArtworkService();

  // Internal state: List of artworks currently displayed and loading status
  List<Artwork> _artworks = [];
  bool _isLoading = false;

  // Public getters to expose state to the UI (e.g., HomeScreen)
  List<Artwork> get artworks => _artworks;
  bool get isLoading => _isLoading;
  int get totalArtworks => _artworks.length;

  // Task 5 – Home Screen (Artwork List): Fetches all artworks from the database for a specific user.
  /// Notifies listeners to show/hide loading indicators during the process.
  Future<void> loadArtworks(int userId) async {
    _isLoading = true;
    notifyListeners(); 
    
    // Fetch data asynchronously from SQLite
    _artworks = await _service.getArtworks(userId);
    
    _isLoading = false;
    notifyListeners(); 
  }

  // Task 6 – Add Artwork: Adds a new artwork to the database.
  /// After adding, it automatically refreshes the local list to keep the UI in sync.
  Future<void> addArtwork(Artwork artwork) async {
    await _service.insertArtwork(artwork);
    // Refresh the list for the user who created it
    await loadArtworks(artwork.createdBy);
  }

  // Task 8 – Update Artwork: Updates an existing artwork's details.
  /// Re-fetches the database content upon successful modification.
  Future<void> updateArtwork(Artwork artwork) async {
    await _service.updateArtwork(artwork);
    await loadArtworks(artwork.createdBy);
  }

  // Task 9 – Delete Artwork: Deletes an artwork from the database using its unique [id].
  /// Requires [userId] to refresh the correct user's collection list.
  Future<void> deleteArtwork(int id, int userId) async {
    await _service.deleteArtwork(id);
    await loadArtworks(userId);
  }

  // Task 10 – Search Artworks: Searches artworks by title keyword for a specific user.
  /// Updates the [_artworks] list reactively as the user types in the search bar.
  Future<void> search(String keyword, int userId) async {
    _artworks = await _service.searchArtworks(keyword, userId);
    notifyListeners();
  }

  // Task 11 – Filter Artworks: Filters artworks based on category and creation year.
  /// Logic: Fetches all artworks then applies filters locally for better performance.
  void filter(String category, String year, int userId) async {
    // 1. Get a fresh copy of all user artworks
    List<Artwork> all = await _service.getArtworks(userId);

    // 2. Apply filtering logic on the collection
    _artworks = all.where((e) {
      // Category filter: match if "All" is selected or if specific category matches
      bool catMatch = category == "All" || e.category == category;

      // Year filter: match if "All" is selected or if artwork was created in last 5 years
      bool yearMatch = year == "All";
      if (year == "Last 5 years") {
        int current = DateTime.now().year;
        int? artYear = int.tryParse(e.year);
        yearMatch = artYear != null && (current - artYear <= 5);
      }

      return catMatch && yearMatch;
    }).toList();

    notifyListeners(); // Refresh the list view in the UI
  }
}
