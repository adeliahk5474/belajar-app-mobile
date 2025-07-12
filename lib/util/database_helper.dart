import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static const _name = 'umkm.db';
  static const _version = 1;

  /// gunakan `DBHelper.database` di semua DAO
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, _name);
    return await openDatabase(
      path,
      version: _version,
      onConfigure: (d) async => d.execute('PRAGMA foreign_keys = ON'),
      onCreate: _createTables,
    );
  }

  /* ─────────────────────────── ORDER HELPERS ─────────────────────────── */

  static Future<void> insertOrder(
    String id,
    String customer,
    String date,
  ) async {
    final db = await database;
    await db.insert('orders', {'id': id, 'customer': customer, 'date': date});
  }

  static Future<void> insertOrderItem(
    String orderId,
    String productId,
    int qty,
    double price,
    String note,
  ) async {
    final db = await database;
    await db.insert('order_items', {
      'orderId': orderId,
      'productId': productId,
      'qty': qty,
      'price': price,
      'note': note,
    });
  }

  static Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;
    return db.query('orders');
  }

  static Future<List<Map<String, dynamic>>> getOrderItems(
    String orderId,
  ) async {
    final db = await database;
    return db.query('order_items', where: 'orderId = ?', whereArgs: [orderId]);
  }

  static Future<void> deleteOrder(String orderId) async {
    final db = await database;
    await db.delete('order_items', where: 'orderId = ?', whereArgs: [orderId]);
    await db.delete('orders', where: 'id = ?', whereArgs: [orderId]);
  }

  /* ─────────────────────────── EMPLOYEE HELPERS ──────────────────────── */

  static Future<void> insertEmployee(
    String id,
    String name,
    String role,
    double salary,
    String? img,
  ) async {
    final db = await database;
    await db.insert('employees', {
      'id': id,
      'name': name,
      'role': role,
      'salary': salary,
      'imageUrl': img,
    });
  }

  static Future<List<Map<String, dynamic>>> getEmployees() async {
    final db = await database;
    return db.query('employees');
  }

  static Future<void> updateEmployee(
    String id,
    String name,
    String role,
    double salary,
    String? img,
  ) async {
    final db = await database;
    await db.update(
      'employees',
      {'name': name, 'role': role, 'salary': salary, 'imageUrl': img},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteEmployee(String id) async {
    final db = await database;
    await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }

  /* ─────────────────────────── TABLE SCHEMA ─────────────────────────── */

  static Future _createTables(Database db, int v) async {
    await db.execute('''
      CREATE TABLE products(
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

    await db.execute('''
      CREATE TABLE employees(
        id TEXT PRIMARY KEY,
        name TEXT,
        role TEXT,
        salary REAL,
        imageUrl TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE orders(
        id TEXT PRIMARY KEY,
        customer TEXT,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items(
        orderId TEXT,
        productId TEXT,
        qty INTEGER,
        price REAL,
        note TEXT,
        FOREIGN KEY(orderId)  REFERENCES orders(id)   ON DELETE CASCADE,
        FOREIGN KEY(productId) REFERENCES products(id) ON DELETE CASCADE
      )
    ''');
  }
}
