import 'package:flutter/material.dart';
import 'package:stock_pilot/services/api_service.dart';
import 'package:stock_pilot/models/item.dart';
import 'package:stock_pilot/add_item_widget.dart';
import 'package:stock_pilot/widgets/item_list.dart';

void main() => runApp(StockPilotApp());

class StockPilotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockPilot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: InventoryHomePage(),
    );
  }
}

class InventoryHomePage extends StatefulWidget {
  @override
  State<InventoryHomePage> createState() => _InventoryHomePageState();
}

class _InventoryHomePageState extends State<InventoryHomePage> {
  final ApiService _api = ApiService();
  List<Item> _items = [];
  bool _loading = true;
  String _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await _api.getItems();
      setState(() { _items = data; });
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _fetch,
          )
        ],
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : _error != null
                ? _ErrorState(message: _error, onRetry: _fetch)
                : ItemList(items: _items, onRefresh: _fetch),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddItemWidget()),
          );
          _fetch();
        },
        icon: Icon(Icons.add),
        label: Text('Add Item'),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
            children: [
          Icon(Icons.warning_amber_rounded, size: 48, color: Colors.amber),
          SizedBox(height: 12),
          Text('Something went wrong', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8),
          Text(message ?? 'Unknown error', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700])),
          SizedBox(height: 16),
          ElevatedButton.icon(onPressed: onRetry, icon: Icon(Icons.refresh), label: Text('Retry'))
        ])
      ),
    );
  }
}

