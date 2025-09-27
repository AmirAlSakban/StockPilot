import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_pilot/models/item.dart';

/// ApiService encapsulates RESTful CRUD operations for inventory Items.
/// Replace [baseUrl] with your actual backend endpoint. The service is kept
/// intentionally minimal; in a production app consider adding interceptors,
/// auth token handling, logging and error abstractions.
class ApiService {
  final String baseUrl = "http://localhost:3000/api/items"; // TODO: configure

  Future<List<Item>> getItems() async {
    final res = await http.get(Uri.parse(baseUrl));
    _ensureSuccess(res, 'fetch items');
    final List<dynamic> body = jsonDecode(res.body) as List<dynamic>;
    return body.map((e) => Item.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Item> getItemById(String id) async {
    final res = await http.get(Uri.parse('$baseUrl/$id'));
    _ensureSuccess(res, 'fetch item');
    return Item.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<Item> createItem(Item item) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: _jsonHeaders,
      body: jsonEncode(item.toJson()),
    );
    _ensureSuccess(res, 'create item');
    return Item.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<Item> updateItem(String id, Item item) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: _jsonHeaders,
      body: jsonEncode(item.toJson()),
    );
    _ensureSuccess(res, 'update item');
    return Item.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<void> deleteItem(String id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    _ensureSuccess(res, 'delete item');
  }

  Map<String, String> get _jsonHeaders => const {
        'Content-Type': 'application/json; charset=UTF-8',
      };

  void _ensureSuccess(http.Response res, String action) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Failed to $action (HTTP ${res.statusCode}): ${res.body}');
    }
  }
}

