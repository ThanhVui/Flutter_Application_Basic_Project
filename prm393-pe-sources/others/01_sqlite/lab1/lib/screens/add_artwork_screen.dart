import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/artwork.dart';
import '../providers/artwork_provider.dart';
import '../providers/auth_provider.dart';

class AddArtworkScreen extends StatefulWidget {
  const AddArtworkScreen({super.key});

  @override
  State<AddArtworkScreen> createState() => _AddArtworkScreenState();
}

class _AddArtworkScreenState extends State<AddArtworkScreen> {
  final _formKey = GlobalKey<FormState>(); // Native Flutter Form Key

  final titleCtrl = TextEditingController();
  final artistCtrl = TextEditingController();
  final yearCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  String selectedCategory = "Abstract";
  final List<String> categories = [
    "Abstract",
    "Realism",
    "Landscape",
    "Portrait",
  ];

  void save() async {
    // Check if form is valid using native validators
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final artworkProvider = context.read<ArtworkProvider>();

    Artwork art = Artwork(
      title: titleCtrl.text.trim(),
      artist: artistCtrl.text.trim(),
      year: yearCtrl.text.trim(),
      category: selectedCategory,
      description: descCtrl.text.trim(),
      createdBy: authProvider.userId!,
    );

    await artworkProvider.addArtwork(art);

    if (mounted) {
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
      appBar: AppBar(title: const Text("Add Artwork")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // Assign Key to Form
          child: Column(
            children: [
              TextFormField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: "Title *",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? "Title is required" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: artistCtrl,
                decoration: const InputDecoration(
                  labelText: "Artist *",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? "Artist is required" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: yearCtrl,
                decoration: const InputDecoration(
                  labelText: "Year *",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Year is required";
                  if (int.tryParse(v) == null) return "Year must be a number";
                  return null;
                },
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => selectedCategory = value!),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: descCtrl,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) =>
                    (v == null || v.isEmpty) ? "Description is required" : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: save,
                  child: const Text("SAVE ARTWORK"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
