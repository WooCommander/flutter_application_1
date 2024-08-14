import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/most_popular_product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../data/data_provider.dart';
import 'add_product_screen.dart';
import 'manage_product_screen.dart';
import '../widgets/product_list_view.dart';

class ProductListScreen extends StatefulWidget {
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
  void _addProduct(String name, double price, double quantity, String group) {
    setState(() {
      final newProduct = Product(
        name: name,
        price: price,
        quantity: quantity,
        date: DateTime.now(), // Присваиваем текущую дату добавления товара
        group: group,
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


  // Метод для удаления продукта с подтверждением
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
              Navigator.of(ctx).pop(); // Закрыть диалог без удаления
            },
            child: Text('Отмена'),
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
            child: Text('Удалить'),
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
        title: Text('Очистить все данные'),
        content: Text('Вы уверены, что хотите очистить все данные?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Закрыть диалог без очистки данных
            },
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              dataProvider.clearData().then((_) {
                setState(() {}); // Обновляем экран после очистки данных
              });
              Navigator.of(ctx).pop(); // Закрыть диалог после очистки
            },
            child: Text('Очистить'),
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
              'name': item.name,
              'price': item.price,
              'quantity': item.quantity,
              'date': item.date.toIso8601String(),
              'group': item.group,
            })
        .toList();
    prefs.setString('products', json.encode(productList));

    final productNameList = dataProvider.productNames
        .map((item) => {
              'name': item.name,
              'group': item.group,
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
            dataProvider.addProductName(
                name, group); // Добавляем новое имя продукта
          });
        },
        productGroups:
            dataProvider.productGroups, // Передаем список групп продуктов
        addProductGroup: (name) {
          setState(() {
            dataProvider
                .addProductGroup(name); // Добавляем новую группу продуктов
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

  @override
  Widget build(BuildContext context) {
    // Получаем информацию о самом популярном товаре
    final mostPopularProduct = dataProvider.getMostPopularProduct();

    return Scaffold(
      appBar: AppBar(
        title: Text('Фиксатор цен'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearData, // Очистка всех данных при нажатии
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _navigateToManageProductScreen(
                context), // Переход на экран управления продуктами
          ),
        ],
      ),
      body: Column(
        children: [
          MostPopularProduct(
            name: mostPopularProduct['name'],
            count: mostPopularProduct['count'],
            lowestPrice: mostPopularProduct['lowestPrice'],
          ),
          Expanded(
            child: ProductListView(
              products: dataProvider
                  .products, // Передаем список продуктов для отображения
              onEdit: _editProduct, // Передаем функцию редактирования продукта
              onDelete: _deleteProduct, // Передаем функцию удаления продукта
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navigateToAddProductScreen(
            context), // Переход на экран добавления продукта
      ),
    );
  }
}
