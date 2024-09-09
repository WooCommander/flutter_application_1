import 'dart:convert';
import 'package:flutter/services.dart';

import 'service_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:flutter_application_1/widgets/most_popular_product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../data/data_provider.dart';
import 'add_product_screen.dart';
import 'manage_product_screen.dart';
import '../widgets/product_list_view.dart';
import 'dart:async';

class ProductListScreen extends StatefulWidget {
  final Function(ThemeMode) onToggleTheme;
  ProductListScreen({required this.onToggleTheme});
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // Экземпляр класса DataProvider для управления данными
  final DataProvider dataProvider = DataProvider();

  @override
  void initState() {
    super.initState();
    // Загружаем данные при инициализации экрана
    _loadData();
  }

  // Асинхронный метод для загрузки данных
  void _loadData() async {
    await dataProvider
        .loadProducts(); // Загружаем продукты и другие данные из SharedPreferences
    setState(() {}); // Обновляем экран после загрузки данных
  }

  // Метод для добавления нового продукта
  void _addProduct(
      String productCode, double price, double quantity, String group) {
    setState(() {
      final newProduct = Product(
        id: dataProvider.generateProductCode(),
        productCode: productCode,
        price: price,
        quantity: quantity,
        date: DateTime.now(), // Присваиваем текущую дату добавления товара
      );
      dataProvider.addProduct(newProduct); // Добавляем продукт в DataProvider
    });
  }

  // Метод для редактирования продукта (реализация может быть добавлена позже)
  void _editProduct(Product product) {
    showDialog(
      context: context,
      builder: (ctx) {
        final _priceController =
            TextEditingController(text: product.price.toString());
        final _quantityController =
            TextEditingController(text: product.quantity.toString());
        return AlertDialog(
          title: Text(S.of(context).editProduct),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: S.of(context).unitPrice),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: S.of(context).quantity),
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
              child: Text(S.of(context).save),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text(S.of(context).cancel),
            ),
          ],
        );
      },
    );
  }

  // Метод для удаления продукта с подтверждением
  void _deleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).deleteProduct),
        content: Text(
            '${S.of(context).confirmDeleteProduct} "${dataProvider.getProductNameById(product.productCode)}"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Закрыть диалог без удаления
            },
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                dataProvider.products
                    .remove(product); // Удаляем продукт из списка
                dataProvider.saveProducts(); // Сохраняем изменения
              });
              Navigator.of(ctx).pop(); // Закрыть диалог после удаления
            },
            child: Text(S.of(context).deleteProduct),
          ),
        ],
      ),
    );
  }

  // Метод для очистки всех данных с подтверждением
  void _clearData() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).clearData),
        content: Text(S.of(context).confirmClearData),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Закрыть диалог без очистки данных
            },
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              dataProvider.clearData().then((_) {
                setState(() {}); // Обновляем экран после очистки данных
              });
              Navigator.of(ctx).pop(); // Закрыть диалог после очистки
            },
            child: Text(S.of(context).clear),
          ),
        ],
      ),
    );
  }

  // Метод для навигации на экран добавления продукта
  void _navigateToAddProductScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddProductScreen(
        addProduct: _addProduct, // Передаем функцию добавления продукта
        existingProducts: dataProvider.products,
        productNames:
            dataProvider.productNames, // Передаем список имен продуктов
        productGroups:
            dataProvider.productGroups, // Передаем список групп продуктов
      ),
    ));
  }

  void _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productList = dataProvider.products
        .map((item) => {
              'productCode': item.productCode,
              'price': item.price,
              'quantity': item.quantity,
              'date': item.date.toIso8601String(),
            })
        .toList();
    prefs.setString('products', json.encode(productList));

    final productNameList = dataProvider.productNames
        .map((item) => {
              'name': item.name,
              'group': item.groupCode,
            })
        .toList();
    prefs.setString('productNames', json.encode(productNameList));

    final productGroupList =
        dataProvider.productGroups.map((item) => {'name': item.name}).toList();
    prefs.setString('productGroups', json.encode(productGroupList));
  }

  // Метод для навигации на экран управления продуктами и группами
  void _navigateToManageProductScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ManageProductScreen(
        addProductName: (name, group) {
          setState(() {
            dataProvider.addProductNameByName(
                name, group); // Добавляем новое имя продукта
          });
        },
        productGroups:
            dataProvider.productGroups, // Передаем список групп продуктов
        addProductGroup: (name) {
          setState(() {
            dataProvider.addProductGroupByName(
                name); // Добавляем новую группу продуктов
          });
        },
        productNames:
            dataProvider.productNames, // Передаем список имен продуктов
        editProductName: (oldName, newName) {
          setState(() {
            final productName = dataProvider.productNames
                .firstWhere((element) => element.name == oldName);
            productName.name = newName; // Изменяем имя продукта
            dataProvider.saveProducts(); // Сохраняем изменения
          });
        },
      ),
    ));
  }

  DateTime? lastPressed;
  Future<bool> _onWillPop() {
    final now = DateTime.now();
    final maxDuration = Duration(seconds: 2);

    if (lastPressed == null || now.difference(lastPressed!) > maxDuration) {
      lastPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Нажмите еще раз, чтобы выйти')),
      );
      return Future.value(false); // Не закрываем приложение, если нажали 1 раз
    }
    SystemNavigator.pop();
    return Future.value(true); // Закрываем приложение, если нажали второй раз
  }
Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Меню',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text('Переключить тему'),
            onTap: () {
              final currentTheme = Theme.of(context).brightness;
              widget.onToggleTheme(
                currentTheme == Brightness.light
                    ? ThemeMode.dark
                    : ThemeMode.light,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Настройки'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      ServiceScreen(dataProvider: dataProvider),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Очистить данные'),
            onTap: () => _clearData(),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Управление продуктами'),
            onTap: () => _navigateToManageProductScreen(context),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // Получаем информацию о самом популярном товаре
    final mostPopularProduct = dataProvider.getMostPopularProduct();
    DataProvider dp = new DataProvider();
    return WillPopScope(
        onWillPop: _onWillPop, // Обрабатываем событие "назад"
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).appTitle),
            actions: [
              IconButton(
                icon: Icon(Icons.brightness_6),
                onPressed: () {
                  // Переключение темы между светлой и темной
                  final currentTheme = Theme.of(context).brightness;
                  widget.onToggleTheme(
                    currentTheme == Brightness.light
                        ? ThemeMode.dark
                        : ThemeMode.light,
                  );
                },
              ),
            
             
            ],
          ),
          drawer: _buildDrawer(context), // Добавляем шторку
          body: Column(
            children: [
              MostPopularProduct(
                name: mostPopularProduct['name'],
                count: mostPopularProduct['count'],
                lowestPrice: mostPopularProduct['lowestPrice'],
              ),
              Expanded(
                child: ProductListView(
                  dataProvider: dataProvider,
                  products: dataProvider.products,
                  productNames: dataProvider.productNames,
                  // .products, // Передаем список продуктов для отображения
                  onEdit:
                      _editProduct, // Передаем функцию редактирования продукта
                  onDelete:
                      _deleteProduct, // Передаем функцию удаления продукта
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _navigateToAddProductScreen(
                context), // Переход на экран добавления продукта
          ),
        ));
  }
}
