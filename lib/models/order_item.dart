class OrderItem {
  final String productId;   // id dari Product
  int qty;
  double unitPrice;

  OrderItem({
    required this.productId,
    required this.qty,
    required this.unitPrice,
  });

  double get subtotal => qty * unitPrice;

  OrderItem copyWith({int? qty, double? unitPrice}) => OrderItem(
        productId: productId,
        qty: qty ?? this.qty,
        unitPrice: unitPrice ?? this.unitPrice,
      );
}
