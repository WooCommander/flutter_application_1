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
   Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'date': date.toIso8601String(),
      'group': group,
    };
  }
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      date: DateTime.parse(json['date']),
      group: json['group'],
    );
  }
  
}

class ProductName {
  String name;
  String group;

  ProductName(this.name, this.group);
    Map<String, dynamic> toJson() {
    return {
      'name': name,
      'group': group,
    };
  }
  factory ProductName.fromJson(Map<String, dynamic> json) {
    return ProductName(
       json['name'],
       json['group'],
    );
  }
}
