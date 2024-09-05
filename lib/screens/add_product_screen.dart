import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/product_group.dart';

class AddProductScreen extends StatefulWidget {
  final Function(String, double, double, String) addProduct;
  final List<ProductName> productNames;
  final List<ProductGroup> productGroups;

  AddProductScreen({
    required this.addProduct,
    required this.productNames,
    required this.productGroups,
  });

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _searchController = TextEditingController();

  String _selectedProductName = '';
  String _selectedProductNameCode = '';
  String _selectedProductGroup = '';
  String _selectedProductGroupCode = '';

  List<ProductName> _filteredProductNames = [];
  Map<String, bool> _groupExpansionState = {}; // Состояние каждой группы

  @override
  void initState() {
    super.initState();
    _filteredProductNames = widget.productNames;
    _searchController.addListener(_filterProducts);

    // Инициализация состояния развернутости для каждой группы
    widget.productGroups.forEach((group) {
      _groupExpansionState[group.groupCode] =
          false; // Изначально все группы свернуты
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Фильтрация товаров по введенному тексту
  void _filterProducts() {
    setState(() {
      String searchText = _searchController.text.toLowerCase();
      _filteredProductNames = widget.productNames
          .where((product) => product.name.toLowerCase().contains(searchText))
          .toList();
    });
  }

  // Функция для раскрытия всех групп
  void _expandAllGroups() {
    setState(() {
      widget.productGroups.forEach((group) {
        _groupExpansionState[group.groupCode] = true;
      });
    });
  }

  // Функция для сворачивания всех групп
  void _collapseAllGroups() {
    setState(() {
      widget.productGroups.forEach((group) {
        _groupExpansionState[group.groupCode] = false;
      });
    });
  }

  void _submitData() {
    if (_selectedProductName.isEmpty ||
        _priceController.text.isEmpty ||
        _quantityController.text.isEmpty) {
      return;
    }

    final enteredPrice = double.parse(_priceController.text);
    final enteredQuantity = double.parse(_quantityController.text);

    if (enteredPrice <= 0 || enteredQuantity <= 0) {
      return;
    }

    widget.addProduct(_selectedProductNameCode, enteredPrice, enteredQuantity,
        _selectedProductGroup);

    _priceController.clear();
    _quantityController.clear();
    setState(() {
      _selectedProductName = '';
      _selectedProductNameCode = '';
      _selectedProductGroup = '';
      _selectedProductGroupCode = '';
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить товар'),
        actions: [
          IconButton(
            icon: Icon(Icons.expand_more), // Иконка для раскрытия всех групп
            onPressed: _expandAllGroups,
          ),
          IconButton(
            icon: Icon(Icons.expand_less), // Иконка для сворачивания всех групп
            onPressed: _collapseAllGroups,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration:
                  InputDecoration(labelText: 'Поиск по названию товара'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.productGroups.length,
                itemBuilder: (ctx, index) {
                  final group = widget.productGroups[index];

                  // Фильтруем товары по группе
                  var filteredProductsInGroup = _filteredProductNames
                      .where((productName) =>
                          productName.groupCode == group.groupCode)
                      .toList();

                  // Если товаров в группе нет, не отображаем группу
                  if (filteredProductsInGroup.isEmpty) {
                    return SizedBox.shrink();
                  }

                  return ExpansionTile(
                    key: UniqueKey(), // Уникальный ключ для каждой группы
                    title: Text(
                      '${group.name} (${filteredProductsInGroup.length})',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Жирный шрифт
                        // color: Colors.amber[900],
                      ),
                    ),
                    initiallyExpanded: _groupExpansionState[group.groupCode] ??
                        false, // Используем состояние развернутости
                    onExpansionChanged: (isExpanded) {
                      setState(() {
                        _groupExpansionState[group.groupCode] = isExpanded;
                      });
                    },
                    children: filteredProductsInGroup.map((productName) {
                      return ListTile(
                        title: Text(productName.name),
                        dense: true, // Уменьшает высоту строки
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16.0), // Отступы
                        onTap: () {
                          setState(() {
                            _selectedProductName = productName.name;
                            _selectedProductNameCode = productName.productCode;
                            _selectedProductGroup = group.name;
                            _selectedProductGroupCode = group.groupCode;
                          });

                          // Показываем диалог для ввода цены и количества
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Введите цену и количество'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _priceController,
                                    decoration: InputDecoration(
                                        labelText: 'Цена за единицу'),
                                    keyboardType: TextInputType.number,
                                  ),
                                  TextField(
                                    controller: _quantityController,
                                    decoration: InputDecoration(
                                        labelText: 'Количество'),
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text('Отмена'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _submitData();
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text('Добавить'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
