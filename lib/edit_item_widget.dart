import 'package:flutter/material.dart';
import 'package:stock_pilot/models/item.dart';
import 'package:stock_pilot/services/api_service.dart';

class EditItemWidget extends StatefulWidget {
  final Item item;
  
  EditItemWidget(this.item);
  
  @override
  _EditItemWidgetState createState() => _EditItemWidgetState();
}

class _EditItemWidgetState extends State<EditItemWidget> {
  final ApiService api = ApiService();
  final _editFormKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _quantityController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize form fields with current item data
    _nameController.text = widget.item.name;
    _descriptionController.text = widget.item.description;
    _priceController.text = widget.item.price.toString();
    _categoryController.text = widget.item.category;
    _quantityController.text = widget.item.quantity.toString();
    _imageUrlController.text = widget.item.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
      ),
      body: Form(
        key: _editFormKey,
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
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              
              // Preview of image
              Container(
                width: double.infinity,
                height: 150,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                  image: DecorationImage(
                    image: NetworkImage(_imageUrlController.text.isNotEmpty ? 
                      _imageUrlController.text : 'https://via.placeholder.com/150'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              // Update button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_editFormKey.currentState.validate()) {
                      _editFormKey.currentState.save();
                      
                      // Create updated Item object
                      final updatedItem = Item(
                        id: widget.item.id,
                        name: _nameController.text,
                        description: _descriptionController.text,
                        price: double.parse(_priceController.text),
                        category: _categoryController.text,
                        quantity: int.parse(_quantityController.text),
                        imageUrl: _imageUrlController.text,
                        createdAt: widget.item.createdAt,
                        updatedAt: DateTime.now().toString(),
                      );
                      
                      // Call API to update item
                      api.updateItem(widget.item.id, updatedItem).then((value) {
                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Item updated successfully')),
                        );
                        Navigator.pop(context, updatedItem);
                      }).catchError((error) {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update item: $error')),
                        );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  child: Text(
                    'UPDATE ITEM',
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
