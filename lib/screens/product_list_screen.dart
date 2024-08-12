// lib/screens/product_list_screen.dart
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
  final List<Product> _products = [Product(name: 'Персик', price:15, date: DateTime(2024, 6,13), group: 'Фрукты')];
  final List<ProductName> _productNames = [];
  final List<ProductGroup> _productGroups = [
    ProductGroup('Фрукты'),
    ProductGroup('Овощи')
  ];
  

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productData = prefs.getString('products');
    final productNameData = prefs.getString('productNames');
    final productGroupData = prefs.getString('productGroups');
    if (productData != null) {
      final productList = json.decode(productData) as List;
      setState(() {
        _products.addAll(productList.map((item) => Product(
              name: item['name'],
              price: item['price'],
              date: DateTime.parse(item['date']),
              group: item['group'],
            )));
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
        _productGroups
            .addAll(productGroupList.map((item) => ProductGroup(item['name'])));
      });
    }
  }

  void _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productList = _products
        .map((item) => {
              'name': item.name,
              'price': item.price,
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

  void _addProduct(String name, double price, String group) {
    setState(() {
      _products.add(Product(
          name: name, price: price, date: DateTime.now(), group: group));
      _saveProducts();
    });
  }

  void _addProductName(String name, String group) {
    setState(() {
      _productNames.add(ProductName(name, group));
      _saveProducts();
    });
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
    setState(() {
      _productGroups.add(ProductGroup(name));
      _saveProducts();
    });
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
            icon: Icon(Icons.edit),
            onPressed: () => _navigateToManageProductScreen(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ProductList(_products),
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
