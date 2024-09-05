import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';
import '../models/product_group.dart';
import '../data/default_data.dart';

class DataProvider {
  List<Product> products = [];
  List<ProductName> productNames = [];
  List<ProductGroup> productGroups = [];

  int _productNameCounter = 0;
  int _productCounter = 0;
  int _groupCounter = 0;

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
        products.addAll(productList.map((item) => Product.fromJson(item)));
      }

      if (productNameData != null) {
        final productNameList = json.decode(productNameData) as List;
        productNames
            .addAll(productNameList.map((item) => ProductName.fromJson(item)));
      }

      if (productGroupData != null) {
        final productGroupList = json.decode(productGroupData) as List;
        productGroups.addAll(
            productGroupList.map((item) => ProductGroup.fromJson(item)));
      }
      _updateCountersBasedOnExistingData();
    }
  }

  void _updateCountersBasedOnExistingData() {
    for (var product in productNames) {
      int productNumber = int.parse(product.productCode.substring(1));
      if (productNumber > _productNameCounter) {
        _productNameCounter = productNumber;
      }
    }

    for (var group in productGroups) {
      int groupNumber = int.parse(group.groupCode.substring(1));
      if (groupNumber > _groupCounter) {
        _groupCounter = groupNumber;
      }

      for (var product in products) {
        int productNumber = int.parse(product.id.substring(1));
        if (productNumber > _productCounter) {
          _productCounter = productNumber;
        }
      }
    }
  }

  Future<void> saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productList = products.map((item) => item.toJson()).toList();
    prefs.setString('products', json.encode(productList));

    final productNameList = productNames.map((item) => item.toJson()).toList();
    prefs.setString('productNames', json.encode(productNameList));

    final productGroupList =
        productGroups.map((item) => item.toJson()).toList();
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

  void addProductName(ProductName value) {
    productNames.add(value);
    saveProducts();
  }

  /// Добавляет новый продукт в справочник товаров.
  ///
  ///[name] - название продукта.
  ///[groupCode] - код группы, к которой относится продукт.
  void addProductNameByName(String name, String groupCode) {
    var product = ProductName(
        productCode: generateProductNameCode(),
        name: name,
        groupCode: groupCode);
    productNames.add(product);
    saveProducts();
  }

  void addProductGroup(ProductGroup group) {
    productGroups.add(group);
    saveProducts();
  }

  void addProductGroupByName(String name) {
    var group = ProductGroup(groupCode: generateGroupCode(), name: name);
    productGroups.add(group);
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
      productCounts[product.productCode] =
          (productCounts[product.productCode] ?? 0) + 1;
      if (lowestPrices[product.productCode] == null ||
          product.price < lowestPrices[product.productCode]!) {
        lowestPrices[product.productCode] = product.price;
      }
    }

    var mostPopularEntry =
        productCounts.entries.reduce((a, b) => a.value > b.value ? a : b);

    String? productName = productNames
        .firstWhere((name) => name.productCode == mostPopularEntry.key)
        .name;
    return {
      'name': productName,
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
          .any((existingGroup) => existingGroup.groupCode == group.groupCode)) {
        productGroups.add(group);
      }
    }

    // Импорт товаров
    for (var productNameJson in data['productNames']) {
      final productName = ProductName.fromJson(productNameJson);
      if (!productNames.any((existingName) =>
          existingName.productCode == productName.productCode)) {
        productNames.add(productName);
      }
    }
    
    // Импорт продуктов
    for (var productJson in data['products']) {
      final product = Product.fromJson(productJson);
      if (!products.any((existingProduct) =>
          existingProduct.productCode == product.productCode &&
          existingProduct.date == product.date &&
          existingProduct.price == product.price &&
          existingProduct.quantity == product.quantity)) {
        product.id = generateProductCode();
        products.add(product);
      }
    }

    // Сохранение данных
    saveProducts();
  }

  String generateProductNameCode() {
    _productNameCounter++;
    return 'P${_productNameCounter.toString().padLeft(3, '0')}';
  }

  String generateProductCode() {
    _productCounter++;
    return 'I${_productCounter.toString().padLeft(3, '0')}';
  }

  String generateGroupCode() {
    _groupCounter++;
    return 'G${_groupCounter.toString().padLeft(3, '0')}';
  }

  String getProductNameById(String code) {
    try {
      // Ищем товар с соответствующим кодом
      final item = productNames.firstWhere(
        (product) => product.productCode == code,
      );
      // Возвращаем имя товара
      return item.name;
    } catch (e) {
      // Если товар не найден, возвращаем значение по умолчанию
      return 'Неизвестный товар';
    }
  }

  String getGroupNameById(String code) {
    try {
      // Ищем товар с соответствующим кодом
      final item = productGroups.firstWhere(
        (product) => product.groupCode == code,
      );
      // Возвращаем имя товара
      return item.name;
    } catch (e) {
      // Если товар не найден, возвращаем значение по умолчанию
      return 'Неизвестный товар';
    }
  }
}
