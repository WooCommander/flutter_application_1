// lib/models/product.dart
class Product {
  String name;
  double price;
  DateTime date;
  String group;

  Product(
      {required this.name,
      required this.price,
      required this.date,
      required this.group});
}

class ProductName {
  String name;
  String group;
  ProductName(this.name, this.group);
}
