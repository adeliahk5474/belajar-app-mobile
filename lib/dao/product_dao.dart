import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import '../models/product.dart';
import '../models/recipe_item.dart';

class ProductDao {
  static Database? _db;

  /* —— singleton getter —— */
  Future<Database> get _database async {
    if (_db != null) return _db!;
    Directory dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'umkm.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, v) async {
        // pastikan tabel ada (aman jika sudah dibuat DBHelper)
        await db.execute('''
          CREATE TABLE IF NOT EXISTS products(
            id TEXT PRIMARY KEY,
            name TEXT,
            category TEXT,
            unit TEXT,
            price REAL,
            stockQty INTEGER,
            minStock INTEGER,
            cloudStockQty INTEGER,
            imageUrl TEXT,
            recipeJson TEXT,
            imagePath TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  /* —— helper konversi recipe list ⇄ JSON —— */
  String? _recipeToJson(List<RecipeItem>? list) =>
      list == null
          ? null
          : jsonEncode(
            list.map((e) => {'id': e.inventoryId, 'qty': e.qty}).toList(),
          );

  List<RecipeItem>? _recipeFromJson(String? json) {
    if (json == null) return null;
    final raw = jsonDecode(json) as List;
    return raw
        .map(
          (m) =>
              RecipeItem(inventoryId: m['id'] as String, qty: m['qty'] as int),
        )
        .toList();
  }

  /* ------------------------------------------------------------- */
  /*  PUBLIC API – dipanggil InventoryController                    */
  /* ------------------------------------------------------------- */

  /// ambil semua produk
  Future<List<Product>> fetchAll() async {
    final db = await _database;
    final rows = await db.query('products');
    return rows
        .map(
          (m) => Product(
            id: m['id'] as String,
            name: m['name'] as String,
            category: m['category'] as String,
            unit: m['unit'] as String,
            price: (m['price'] as num).toDouble(),
            stockQty: m['stockQty'] as int,
            minStock: m['minStock'] as int,
            cloudStockQty: m['cloudStockQty'] as int?,
            imageUrl: m['imageUrl'] as String?,
            imagePath: m['imagePath'] as String?,
            recipe: _recipeFromJson(m['recipeJson'] as String?),
          ),
        )
        .toList();
  }

  /// insert / replace
  Future<void> insert(Product p) async {
    final db = await _database;
    await db.insert(
      'products',
      _toMap(p),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// update by id
  Future<void> update(Product p) async {
    final db = await _database;
    await db.update('products', _toMap(p), where: 'id = ?', whereArgs: [p.id]);
  }

  /// delete by id
  Future<void> delete(String id) async {
    final db = await _database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  /* —— helper konversi Product → Map —— */
  Map<String, dynamic> _toMap(Product p) => {
    'id': p.id,
    'name': p.name,
    'category': p.category,
    'unit': p.unit,
    'price': p.price,
    'stockQty': p.stockQty,
    'minStock': p.minStock,
    'cloudStockQty': p.cloudStockQty,
    'imageUrl': p.imageUrl,
    'recipeJson': _recipeToJson(p.recipe),
    'imagePath': p.imagePath,
  };
}
