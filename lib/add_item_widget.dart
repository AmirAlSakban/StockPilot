import 'package:flutter/material.dart';
import 'package:stock_pilot/models/item.dart';
import 'package:stock_pilot/services/api_service.dart';

class AddItemWidget extends StatefulWidget {
  @override
  _AddItemWidgetState createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  final ApiService api = ApiService();
  final _addFormKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _quantityController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Form(
        key: _addFormKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Description field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Price field
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Category field
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Quantity field
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Image URL field
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                  hintText: 'https://example.com/image.jpg',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  // You could add URL validation here
                  return null;
                },
              ),
              SizedBox(height: 24),
              
              // Preview of image URL (if available)
              if (_imageUrlController.text.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 150,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                    image: DecorationImage(
                      image: NetworkImage(_imageUrlController.text),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        // Handle error loading image
                      },
                    ),
                  ),
                ),
              
              // Add button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_addFormKey.currentState.validate()) {
                      _addFormKey.currentState.save();
                      
                      // Create Item object
                      final item = Item(
                        name: _nameController.text,
                        description: _descriptionController.text,
                        price: double.parse(_priceController.text),
                        category: _categoryController.text,
                        quantity: int.parse(_quantityController.text),
                        imageUrl: _imageUrlController.text,
                      );
                      
                      // Call API to create item
                      api.createItem(item).then((value) {
                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Item added successfully')),
                        );
                        Navigator.pop(context);
                      }).catchError((error) {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add item: $error')),
                        );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  child: Text(
                    'ADD ITEM',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
