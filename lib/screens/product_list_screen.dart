import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';
import '../models/product_group.dart';
import '../widgets/product_list.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';
import 'manage_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<Product> _products = [];
  final List<Product> _filteredProducts = [];
  final List<ProductName> _productNames = [];
  final List<ProductGroup> _productGroups = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
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
        setState(() {
          _products.addAll(productList.map((item) => Product(
                name: item['name'],
                price: item['price'],
                quantity: (item['quantity'] as num).toDouble(),
                date: DateTime.parse(item['date']),
                group: item['group'],
              )));
          _filteredProducts.addAll(_products);
        });
      }

      if (productNameData != null) {
        final productNameList = json.decode(productNameData) as List;
        setState(() {
          _productNames.addAll(productNameList
              .map((item) => ProductName(item['name'], item['group'])));
        });
      }

      if (productGroupData != null) {
        final productGroupList = json.decode(productGroupData) as List;
        setState(() {
          _productGroups.addAll(
              productGroupList.map((item) => ProductGroup(item['name'])));
        });
      }
    }
  }

  void _initializeDefaultData() {
    _addProductGroup('Фрукты');
    _addProductGroup('Овощи');

    _addProductName('Персик', 'Фрукты');
    _addProductName('Яблоко', 'Фрукты');
    _addProductName('Груша', 'Фрукты');
    _addProductName('Капуста', 'Овощи');
    _addProductName('Морковка', 'Овощи');
  }

  void _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productList = _products
        .map((item) => {
              'name': item.name,
              'price': item.price,
              'quantity': item.quantity,
              'date': item.date.toIso8601String(),
              'group': item.group,
            })
        .toList();
    prefs.setString('products', json.encode(productList));

    final productNameList = _productNames
        .map((item) => {
              'name': item.name,
              'group': item.group,
            })
        .toList();
    prefs.setString('productNames', json.encode(productNameList));

    final productGroupList =
        _productGroups.map((item) => {'name': item.name}).toList();
    prefs.setString('productGroups', json.encode(productGroupList));
  }

  void _filterProducts(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredProducts.clear();
      _filteredProducts.addAll(
        _products.where((product) {
          return product.name.toLowerCase().contains(_searchQuery) ||
              product.group.toLowerCase().contains(_searchQuery);
        }).toList(),
      );
    });
  }

  void _clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    setState(() {
      _products.clear();
      _filteredProducts.clear();
      _productNames.clear();
      _productGroups.clear();
    });
  }

  void _addProduct(String name, double price, double quantity, String group) {
    setState(() {
      final newProduct = Product(
        name: name,
        price: price,
        quantity: quantity,
        date: DateTime.now(),
        group: group,
      );
      _products.add(newProduct);
      _filteredProducts.add(newProduct);
      _saveProducts();
    });
  }

  void _editProduct(Product product) {
    showDialog(
      context: context,
      builder: (ctx) {
        final _priceController =
            TextEditingController(text: product.price.toString());
        final _quantityController =
            TextEditingController(text: product.quantity.toString());
        return AlertDialog(
          title: Text('Редактировать товар'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Цена за единицу'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Количество'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  product.price = double.parse(_priceController.text);
                  product.quantity = double.parse(_quantityController.text);
                  _saveProducts();
                });
                Navigator.of(ctx).pop();
              },
              child: Text('Сохранить'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Удалить товар'),
        content:
            Text('Вы уверены, что хотите удалить товар "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _products.remove(product);
                _filteredProducts.remove(product);
                _saveProducts();
              });
              Navigator.of(ctx).pop();
            },
            child: Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _addProductName(String name, String group) {
    bool productExists = _productNames.any((productName) =>
        productName.name == name && productName.group == group);

    if (!productExists) {
      setState(() {
        _productNames.add(ProductName(name, group));
        _saveProducts();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Товар "$name" уже существует в группе "$group"!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _editProductName(String oldName, String newName) {
    setState(() {
      for (var product in _products) {
        if (product.name == oldName) {
          product.name = newName;
        }
      }
      for (var productName in _productNames) {
        if (productName.name == oldName) {
          productName.name = newName;
        }
      }
      _saveProducts();
    });
  }

  void _addProductGroup(String name) {
    bool groupExists = _productGroups.any((group) => group.name == name);

    if (!groupExists) {
      setState(() {
        _productGroups.add(ProductGroup(name));
        _saveProducts();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Группа "$name" уже существует!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToAddProductScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddProductScreen(
        addProduct: _addProduct,
        productNames: _productNames,
        productGroups: _productGroups,
      ),
    ));
  }

  void _navigateToManageProductScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ManageProductScreen(
        addProductName: _addProductName,
        productGroups: _productGroups,
        addProductGroup: _addProductGroup,
        productNames: _productNames,
        editProductName: _editProductName,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Фиксатор цен'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _clearData(),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _navigateToManageProductScreen(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Поиск товаров...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _filterProducts(
                    value); // Обновление списка при изменении текста
              },
            ),
          ),
          Expanded(
            child: ProductList(
              _filteredProducts, // Используем отфильтрованный список
              onEdit: _editProduct,
              onDelete: _deleteProduct,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navigateToAddProductScreen(context),
      ),
    );
  }
}
