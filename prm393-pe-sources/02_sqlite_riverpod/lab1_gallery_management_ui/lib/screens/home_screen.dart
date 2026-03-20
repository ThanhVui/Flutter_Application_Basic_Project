import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/artwork_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/favorite_provider.dart';
import 'favorite_artwork_screen.dart';
import 'add_artwork_screen.dart';
import 'artwork_detail_screen.dart';
import 'login_screen.dart';

/// Main Dashboard screen displaying a summary of the gallery using Riverpod.
/// Includes banners, statistics, search/filter functionality, and the artwork list.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Local state for current filter selections
  String selectedCategory = "All";
  String selectedYear = "All";

  @override
  void initState() {
    super.initState();
    // Load initial data from SQLite via Providers after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(authProvider).userId!;
      ref.read(artworkProvider).loadArtworks(userId);
      ref.read(favoriteProvider).loadFavorites(userId);
    });
  }

  /// Clears the user session and navigates back to the LoginScreen.
  void logout() async {
    await ref.read(authProvider).logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  /// Triggers a live search based on the user's keystrokes.
  void search(String keyword) {
    final userId = ref.read(authProvider).userId!;
    ref.read(artworkProvider).search(keyword, userId);
  }

  /// Applies the selected Category and Year filters to the artwork list.
  void applyFilter() {
    final userId = ref.read(authProvider).userId!;
    ref.read(artworkProvider).filter(selectedCategory, selectedYear, userId);
  }

  /// Helper to calculate the unique number of categories available in the current collection.
  int countCategories() {
    final artworks = ref.read(artworkProvider).artworks;
    final categories = artworks.map((e) => e.category).toSet();
    return categories.length;
  }

  @override
  Widget build(BuildContext context) {
    // Watching providers to reactively update the UI when data changes via Riverpod
    final auth = ref.watch(authProvider);
    final artwork = ref.watch(artworkProvider);
    final favorite = ref.watch(favoriteProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Slate-light background
      appBar: AppBar(
        title: const Text("Gallery Dashboard", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Navigation to the Favorites sub-screen
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded, color: Color(0xFF64748B)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoriteScreen()));
            },
          ),
          // Logout functionality
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF64748B)),
            onPressed: logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. BRAND BANNER SECTION: Displays the decorative header image
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'lib/assets/gallery_header.jpg',
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 2. WELCOME SECTION: Greets the logged-in user with their name from AuthProvider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF148585),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.home_work_rounded, color: Color(0xFF148585)),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Gallery Collection", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("Welcome back, ${auth.username ?? 'User'}", style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 3. STATISTICS SECTION: Quick overview of Artworks, Favorites, and Categories
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text("Gallery Statistics", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statCard(Icons.photo_library_outlined, artwork.totalArtworks.toString(), "Artworks"),
                    _statCard(Icons.favorite_border_rounded, favorite.totalFavorites.toString(), "Favorites"),
                    _statCard(Icons.category_outlined, countCategories().toString(), "Categories"),
                  ],
                ),
              ),
            ),

            // 4. SEARCH & FILTERS SECTION: Responsive inputs for narrowing down the collection
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    // Dynamic Search Input
                    TextField(
                      onChanged: search,
                      decoration: InputDecoration(
                        hintText: "Search by title...",
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Dropdown filters for Year and Category
                    Row(
                      children: [
                        Expanded(
                          child: _buildFilterDropdown("Year filter", selectedYear, ["All", "Last 5 years"], (v) {
                            setState(() => selectedYear = v!);
                            applyFilter();
                          }),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildFilterDropdown("Category", selectedCategory, ["All", "Abstract", "Realism", "Landscape", "Portrait"], (v) {
                            setState(() => selectedCategory = v!);
                            applyFilter();
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 5. ARTWORK COLLECTION LIST: Dynamically rendered list of the user's artworks
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text("Artwork Collection (${artwork.artworks.length})", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            
            artwork.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Scroll managed by SingleChildScrollView
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: artwork.artworks.length,
                    itemBuilder: (_, index) {
                      var art = artwork.artworks[index];
                      // Each list item is wrapped in a Material Card
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFA7F3D0).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.palette_outlined, color: Color(0xFF065F46)),
                          ),
                          title: Text(art.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("${art.artist} • ${art.year}", style: const TextStyle(color: Color(0xFF64748B))),
                          trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFCBD5E1)),
                          onTap: () {
                            // Navigate to the detailed view of the selected artwork
                            Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(artwork: art)));
                          },
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 100), // Ensures scroll space for the FloatingActionButton
          ],
        ),
      ),
      // Action button to navigate to the 'Add Artwork' form
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFA7F3D0),
        foregroundColor: const Color(0xFF065F46),
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text("Add Artwork", style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddArtworkScreen()));
        },
      ),
    );
  }

  /// Reusable widget for displaying a single statistics metric.
  Widget _statCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF148585), size: 20),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }

  /// Reusable widget to build labeled dropdown menus used for filtering.
  Widget _buildFilterDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
      onChanged: onChanged,
    );
  }
}
