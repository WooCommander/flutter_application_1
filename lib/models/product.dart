/**
 * основная таблица с добавленными товарами 
 */
class Product {
  String id;
  String productCode;
  double price;
  DateTime date;
  double quantity;

  Product(
      {required this.id,
      required this.productCode,
      required this.price,
      required this.date,
      required this.quantity});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productCode: json['productCode'],
      price: json['price'],
      date: DateTime.parse(json['date']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {

      'id': id,
      'productCode': productCode,
        // Преобразуем DateTime в строку для JSON
      'date': date.toIso8601String(),
      'price': price,
      'quantity': quantity,
    };
  }
}

/**
 * Справочник товаров
 */
class ProductName {
  String productCode;
  String name;
  String groupCode; // Код группы, к которой относится товар

  ProductName(
      {required this.productCode, required this.name, required this.groupCode});

  factory ProductName.fromJson(Map<String, dynamic> json) {
    return ProductName(
      productCode: json['productCode'],
      name: json['name'],
      groupCode: json['groupCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productCode': productCode,
      'name': name,
      'groupCode': groupCode,
    };
  }
}
