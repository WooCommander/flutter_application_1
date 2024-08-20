import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';
import '../models/product_group.dart';
import '../data/default_data.dart';

class DataProvider {
  List<Product> products = [];
  List<ProductName> productNames = [];
  List<ProductGroup> productGroups = [];

  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final isInitialized = prefs.getBool('isInitialized') ?? false;

    if (!isInitialized) {
      _initializeDefaultData();
      await prefs.setBool('isInitialized', true);
    } else {
      final productData = prefs.getString('products');
      final productNameData = prefs.getString('productNames');
      final productGroupData = prefs.getString('productGroups');

      if (productData != null) {
        final productList = json.decode(productData) as List;
        products.addAll(productList.map((item) => Product(
              name: item['name'],
              price: item['price'],
              quantity: (item['quantity'] as num).toDouble(),
              date: DateTime.parse(item['date']),
              group: item['group'],
            )));
      }

      if (productNameData != null) {
        final productNameList = json.decode(productNameData) as List;
        productNames.addAll(productNameList
            .map((item) => ProductName(item['name'], item['group'])));
      }

      if (productGroupData != null) {
        final productGroupList = json.decode(productGroupData) as List;
        productGroups
            .addAll(productGroupList.map((item) => ProductGroup(item['name'])));
      }
    }
  }

  Future<void> saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productList = products
        .map((item) => {
              'name': item.name,
              'price': item.price,
              'quantity': item.quantity,
              'date': item.date.toIso8601String(),
              'group': item.group,
            })
        .toList();
    prefs.setString('products', json.encode(productList));

    final productNameList = productNames
        .map((item) => {
              'name': item.name,
              'group': item.group,
            })
        .toList();
    prefs.setString('productNames', json.encode(productNameList));

    final productGroupList =
        productGroups.map((item) => {'name': item.name}).toList();
    prefs.setString('productGroups', json.encode(productGroupList));
  }

  void _initializeDefaultData() {
    productGroups.addAll(defaultProductGroups);
    productNames.addAll(defaultProductNames);
  }

  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    products.clear();
    productNames.clear();
    productGroups.clear();
  }

  void addProduct(Product product) {
    products.add(product);
    saveProducts();
  }

  void addProductName(String name, String group) {
    productNames.add(ProductName(name, group));
    saveProducts();
  }

  void addProductGroup(String name) {
    productGroups.add(ProductGroup(name));
    saveProducts();
  }

  Map<String, dynamic> getMostPopularProduct() {
    if (products.isEmpty) {
      return {
        'name': 'Нет данных',
        'count': 0,
        'lowestPrice': null,
      };
    }

    Map<String, int> productCounts = {};
    Map<String, double> lowestPrices = {};

    for (var product in products) {
      productCounts[product.name] = (productCounts[product.name] ?? 0) + 1;
      if (lowestPrices[product.name] == null ||
          product.price < lowestPrices[product.name]!) {
        lowestPrices[product.name] = product.price;
      }
    }

    var mostPopularEntry =
        productCounts.entries.reduce((a, b) => a.value > b.value ? a : b);

    return {
      'name': mostPopularEntry.key,
      'count': mostPopularEntry.value,
      'lowestPrice': lowestPrices[mostPopularEntry.key],
    };
  }

  Future<String> exportDataToJson() async {
    // Собираем данные
    final data = {
      'productGroups': productGroups.map((group) => group.toJson()).toList(),
      'products': products.map((product) => product.toJson()).toList(),
      'productNames':
          productNames.map((productName) => productName.toJson()).toList(),
    };

    // Конвертируем в JSON
    return jsonEncode(data);
  }

  Future<void> importDataFromJson(String jsonData) async {
    final Map<String, dynamic> data = jsonDecode(jsonData);

    // Импорт групп
    for (var groupJson in data['productGroups']) {
      final group = ProductGroup.fromJson(groupJson);
      if (!productGroups
          .any((existingGroup) => existingGroup.name == group.name)) {
        productGroups.add(group);
      }
    }

    // Импорт товаров
    for (var productJson in data['products']) {
      final product = Product.fromJson(productJson);
      if (!products.any((existingProduct) =>
          existingProduct.name == product.name &&
          existingProduct.group == product.group &&
          existingProduct.date == product.date)) {
        products.add(product);
      }
    }

    // Сохранение данных
    saveProducts();
  }
}
