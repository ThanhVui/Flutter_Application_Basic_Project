import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/artwork_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/favorite_provider.dart';
import 'favorite_artwork_screen.dart';
import 'add_artwork_screen.dart';
import 'artwork_detail_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "All";
  String selectedYear = "All";

  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding to wait for the first frame before loading data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().userId!;
      context.read<ArtworkProvider>().loadArtworks(userId);
      context.read<FavoriteProvider>().loadFavorites(userId);
    });
  }

  void logout() async {
    await context.read<AuthProvider>().logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void search(String keyword) {
    final userId = context.read<AuthProvider>().userId!;
    context.read<ArtworkProvider>().search(keyword, userId);
  }

  void applyFilter() {
    final userId = context.read<AuthProvider>().userId!;
    context.read<ArtworkProvider>().filter(selectedCategory, selectedYear, userId);
  }

  int countCategories() {
    final artworks = context.read<ArtworkProvider>().artworks;
    final categories = artworks.map((e) => e.category).toSet();
    return categories.length;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final artworkProvider = context.watch<ArtworkProvider>();
    final favoriteProvider = context.watch<FavoriteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gallery Manager"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoriteScreen()),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),
      body: Column(
        children: [
          // Statistics Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem("Artworks", artworkProvider.totalArtworks),
                    _statItem("Favorites", favoriteProvider.totalFavorites),
                    _statItem("Categories", countCategories()),
                  ],
                ),
              ),
            ),
          ),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search by title...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: search,
            ),
          ),
          
          // Filters
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(labelText: "Category"),
                    items: ["All", "Abstract", "Realism", "Landscape", "Portrait"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      setState(() => selectedCategory = v!);
                      applyFilter();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedYear,
                    decoration: const InputDecoration(labelText: "Year"),
                    items: ["All", "Last 5 years"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      setState(() => selectedYear = v!);
                      applyFilter();
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // List of Artworks
          Expanded(
            child: artworkProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : artworkProvider.artworks.isEmpty
                    ? const Center(child: Text("No artworks found"))
                    : RefreshIndicator(
                        onRefresh: () async {
                          artworkProvider.loadArtworks(authProvider.userId!);
                        },
                        child: ListView.builder(
                          itemCount: artworkProvider.artworks.length,
                          itemBuilder: (_, index) {
                            var art = artworkProvider.artworks[index];
                            return ListTile(
                              leading: CircleAvatar(child: Text(art.category[0])),
                              title: Text(art.title),
                              subtitle: Text("${art.artist} • ${art.year}"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailScreen(artwork: art),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddArtworkScreen()),
          );
        },
      ),
    );
  }

  Widget _statItem(String label, int value) {
    return Column(
      children: [
        Text(value.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
