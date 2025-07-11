import 'order_item.dart';

class Order {
  final String id;
  String customer;
  DateTime date;
  List<OrderItem> items;

  Order({
    required this.id,
    required this.customer,
    required this.date,
    required this.items,
  });

  double get total =>
      items.fold(0, (sum, i) => sum + i.subtotal);

  Order copyWith({
    String? customer,
    DateTime? date,
    List<OrderItem>? items,
  }) =>
      Order(
        id: id,
        customer: customer ?? this.customer,
        date: date ?? this.date,
        items: items ?? this.items,
      );
}
