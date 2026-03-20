import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import '../services/notification_service.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  
  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late String _selectedCategory;

  bool get isEditing => widget.product != null;

  final List<String> _categories = [
    'electronics',
    'jewelery',
    "men's clothing",
    "women's clothing"
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product?.title ?? '');
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _selectedCategory = widget.product?.category ?? 'electronics';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (isEditing) {
        // Update existing product
        widget.product!.title = _titleController.text;
        widget.product!.price = double.parse(_priceController.text);
        widget.product!.description = _descriptionController.text;
        widget.product!.category = _selectedCategory;
        
        context.read<ProductProvider>().updateProduct(widget.product!);
        
        NotificationService().showNotification(
          2,
          'Product Updated',
          '"${widget.product!.title}" has been updated.',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully')),
        );
      } else {
        // Add new product
        final newProduct = Product(
          id: DateTime.now().millisecondsSinceEpoch,
          title: _titleController.text,
          price: double.parse(_priceController.text),
          description: _descriptionController.text,
          category: _selectedCategory,
          image: 'https://i.pravatar.cc/300',
        );

        context.read<ProductProvider>().addProduct(newProduct);
        
        NotificationService().showNotification(
          1,
          'Product Added',
          'New product "${newProduct.title}" has been added to inventory.',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully')),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Product' : 'Add New Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Save Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
