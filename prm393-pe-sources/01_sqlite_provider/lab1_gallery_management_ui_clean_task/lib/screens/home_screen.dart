import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/artwork_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/favorite_provider.dart';
import 'favorite_artwork_screen.dart';
import 'add_artwork_screen.dart';
import 'artwork_detail_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

// ==========================================================================
// SCREEN: HOME SCREEN
// Task 5 – Home Screen (Artwork List)
// ==========================================================================
/// Main Dashboard screen displaying a summary of the gallery.
/// Includes banners, statistics, search/filter functionality, and the artwork list.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --------------------------------------------------------------------------
  // 1. STATE VARIABLES
  // --------------------------------------------------------------------------
  String selectedCategory = "All";
  String selectedYear = "All";
  // Task 16: Track which sort is currently active for UI feedback
  String selectedSortOrder = "A-Z";

  // --------------------------------------------------------------------------
  // 2. INITIALIZATION
  // --------------------------------------------------------------------------
  void initState() {
    super.initState();
    // Load initial data from SQLite via Providers after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().userId!;
      context.read<ArtworkProvider>().loadArtworks(userId);
      context.read<FavoriteProvider>().loadFavorites(userId);
    });
  }

  // --------------------------------------------------------------------------
  // 3. CORE FUNCTIONAL ACTIONS
  // --------------------------------------------------------------------------
  // Task 4 – Logout (Action): Clears the user session and navigates back to the LoginScreen.
  void logout() async {
    await context.read<AuthProvider>().logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  // Task 10 – Search Artworks (Action): Triggers a live search based on the user's keystrokes.
  void search(String keyword) {
    final userId = context.read<AuthProvider>().userId!;
    context.read<ArtworkProvider>().search(keyword, userId);
  }

  // Task 11 – Filter Artworks (Action): Applies the selected Category and Year filters to the artwork list.
  void applyFilter() {
    final userId = context.read<AuthProvider>().userId!;
    context.read<ArtworkProvider>().filter(selectedCategory, selectedYear, userId);
  }

  @override
  Widget build(BuildContext context) {
    // Watching providers to reactively update the UI when data changes
    final authProvider = context.watch<AuthProvider>();
    final artworkProvider = context.watch<ArtworkProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), 
      // ----------------------------------------------------------------------
      // SECTION: APP BAR (HEADER)
      // Contains: Profile Icon (Task 15), Title, Favorites, Logout (Task 4)
      // ----------------------------------------------------------------------
      appBar: AppBar(
        title: const Text("Gallery Dashboard", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        // Task 15 – User Profile (Navigation): Added profile icon to the leading part of the header
        leading: IconButton(
          icon: const Icon(Icons.person_outline_rounded, color: Color(0xFF64748B)),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
          },
        ),
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
      // ----------------------------------------------------------------------
      // SECTION: BODY (SCROLLABLE CONTENT)
      // ----------------------------------------------------------------------
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
                        Text("Welcome back, ${authProvider.username ?? 'User'}", style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Task 14 – Gallery Statistics: Quick overview of Artworks, Favorites, and Categories
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
                    _statCard(Icons.photo_library_outlined, artworkProvider.totalArtworks.toString(), "Artworks"),
                    _statCard(Icons.favorite_border_rounded, favoriteProvider.totalFavorites.toString(), "Favorites"),
                    _statCard(Icons.category_outlined, artworkProvider.totalCategories.toString(), "Categories"),
                  ],
                ),
              ),
            ),

            // Task 10 & 11 – SEARCH & FILTERS SECTION: Responsive inputs for narrowing down the collection
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
                    const SizedBox(height: 16),
                    // Task 16 – Sorting Buttons: Allows users to sort the list by Year or Title
                    // Task 16 – Sorting Section: Reorganized for more explicit sorting options
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Sort by Title:", style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildSortChip("A-Z", artworkProvider, "Title", true),
                            const SizedBox(width: 8),
                            _buildSortChip("Z-A", artworkProvider, "Title", false),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text("Sort by Year:", style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildSortChip("Oldest", artworkProvider, "Year", true),
                            const SizedBox(width: 8),
                            _buildSortChip("Newest", artworkProvider, "Year", false),
                          ],
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
              child: Text("Artwork Collection (${artworkProvider.artworks.length})", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            
            artworkProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Scroll managed by SingleChildScrollView
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: artworkProvider.artworks.length,
                    itemBuilder: (_, index) {
                      var art = artworkProvider.artworks[index];
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
            const SizedBox(height: 100), 
          ],
        ),
      ),
      // ----------------------------------------------------------------------
      // SECTION: FLOATING ACTION BUTTON
      // Task 6 – Add Artwork: Navigates to the input form
      // ----------------------------------------------------------------------
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

  // --------------------------------------------------------------------------
  // 4. REUSABLE HELPER UI COMPONENTS
  // --------------------------------------------------------------------------
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

  /// Task 16 – Sorting Chip: Updated to handle explicit criteria and order with active state
  Widget _buildSortChip(String label, ArtworkProvider provider, String criteria, bool asc) {
    final isSelected = selectedSortOrder == label;
    return ActionChip(
      label: Text(label, style: TextStyle(
        fontSize: 12, 
        color: isSelected ? Colors.white : const Color(0xFF64748B),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      )),
      backgroundColor: isSelected ? const Color(0xFF148585) : const Color(0xFFF1F5F9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide.none,
      onPressed: () {
        setState(() => selectedSortOrder = label);
        provider.sortArtworks(criteria, asc);
      },
      elevation: 0,
      pressElevation: 2,
    );
  }
}
