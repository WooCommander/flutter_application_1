class ProductGroup {
  String groupCode;
  String name;

  ProductGroup({required this.groupCode, required this.name});

  factory ProductGroup.fromJson(Map<String, dynamic> json) {
    return ProductGroup(
      groupCode: json['groupCode'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupCode': groupCode,
      'name': name,
    };
  }
}
