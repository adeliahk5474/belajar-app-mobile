import 'package:flutter/material.dart';

class Product {
  final String id;
  String name;
  String category;
  String unit;        //pcs, kg, pack, dll
  double price;
  int stockQty;
  int minStock;


  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.price,
    required this.stockQty,
    this.minStock = 0,
  });
}
