// lib/models/product_group.dart
class ProductGroup {
  String name;

  ProductGroup(this.name);
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
  factory ProductGroup.fromJson(Map<String, dynamic> json) {
    return ProductGroup(
      json['name'],
    );
  }
}
