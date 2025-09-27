import 'package:flutter/material.dart';
import 'package:stock_pilot/models/item.dart';
import 'package:stock_pilot/services/api_service.dart';
import 'package:stock_pilot/edit_item_widget.dart';

class ItemDetailWidget extends StatefulWidget {
  final Item item;

  ItemDetailWidget(this.item);

  @override
  _ItemDetailWidgetState createState() => _ItemDetailWidgetState();
}

class _ItemDetailWidgetState extends State<ItemDetailWidget> {
  final ApiService api = ApiService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditItemWidget(widget.item),
                ),
              ).then((value) {
                setState(() {});
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Image
            Center(
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.item.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),
            
            // Title and Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.item.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '\$${widget.item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 8),
            // Category
            Text(
              'Category: ${widget.item.category}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            
            SizedBox(height: 16),
            // Quantity
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Quantity in stock: ${widget.item.quantity}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue[700],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            // Description title
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 8),
            // Description content
            Text(
              widget.item.description,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            
            SizedBox(height: 24),
            // Item metadata
            _buildInfoRow('Item ID', widget.item.id),
            _buildInfoRow('Created', widget.item.createdAt),
            _buildInfoRow('Updated', widget.item.updatedAt),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'DELETE',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                api.deleteItem(widget.item.id).then((value) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }).catchError((error) {
                  print("Error deleting the item: $error");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete the item')),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }
}
