import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/artwork.dart';
import '../providers/artwork_provider.dart';
import '../providers/auth_provider.dart';

/// Screen for adding a new artwork to the collection.
/// Includes a Form with validation for Title, Artist, Year, and Description.
class AddArtworkScreen extends StatefulWidget {
  const AddArtworkScreen({super.key});

  @override
  State<AddArtworkScreen> createState() => _AddArtworkScreenState();
}

class _AddArtworkScreenState extends State<AddArtworkScreen> {
  // Key to identify and validate the form
  final _formKey = GlobalKey<FormState>();

  // Text controllers to capture user input
  final titleCtrl = TextEditingController();
  final artistCtrl = TextEditingController();
  final yearCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  // Predefined categories for the dropdown menu
  String selectedCategory = "Abstract";
  final List<String> categories = [
    "Abstract",
    "Realism",
    "Landscape",
    "Portrait",
  ];

  /// Gathers input data, validates it, and saves a new Artwork to SQLite.
  void save() async {
    // 1. Run native Flutter field validators
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final artworkProvider = context.read<ArtworkProvider>();

    // 2. Map text field values to a new Artwork model instance
    Artwork art = Artwork(
      title: titleCtrl.text.trim(),
      artist: artistCtrl.text.trim(),
      year: yearCtrl.text.trim(),
      category: selectedCategory,
      description: descCtrl.text.trim(),
      createdBy: authProvider.userId!, // Link artwork to the currently logged-in user
    );

    // 3. Persist the new artwork using the provider
    await artworkProvider.addArtwork(art);

    if (mounted) {
      // 4. Provide visual feedback and return to previous screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Artwork added successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Light background
      appBar: AppBar(
        title: const Text("Add Artwork", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "New Artwork",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Input for Artwork Title
                _buildTextField(
                  controller: titleCtrl,
                  label: "Title",
                  icon: Icons.title_rounded,
                  validator: (v) => (v == null || v.isEmpty) ? "Title is required" : null,
                ),
                const SizedBox(height: 20),
                
                // Input for Artist Name
                _buildTextField(
                  controller: artistCtrl,
                  label: "Artist",
                  icon: Icons.person_outline_rounded,
                  validator: (v) => (v == null || v.isEmpty) ? "Artist is required" : null,
                ),
                const SizedBox(height: 20),
                
                // Input for Compilation Year with numeric check
                _buildTextField(
                  controller: yearCtrl,
                  label: "Year",
                  icon: Icons.calendar_today_rounded,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Year is required";
                    if (int.tryParse(v) == null) return "Year must be a number";
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Selection for Artwork Category
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: "Category",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: const Icon(Icons.category_outlined, color: Color(0xFF64748B)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                  items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                  onChanged: (value) => setState(() => selectedCategory = value!),
                ),
                const SizedBox(height: 20),
                
                // Multi-line input for Description
                _buildTextField(
                  controller: descCtrl,
                  label: "Description",
                  icon: Icons.notes_rounded,
                  maxLines: 4,
                  validator: (v) => (v == null || v.isEmpty) ? "Description is required" : null,
                ),
                const SizedBox(height: 32),
                
                // Main save action button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00796B), // Teal Theme
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Save Artwork",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper method to create consistently styled TextFields across the form.
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      validator: validator,
    );
  }
}
