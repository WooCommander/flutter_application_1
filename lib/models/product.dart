// lib/models/product.dart
class Product {
  String name;
  double price; // цена за единицу
  double quantity;
  DateTime date;
  String group;

  Product({
    required this.name,
    required this.price,
    required this.quantity,
    required this.date,
    required this.group,
  });

  double get totalPrice => price * quantity; // вычисление общей стоимости
}

class ProductName {
  String name;
  String group;

  ProductName(this.name, this.group);
}
