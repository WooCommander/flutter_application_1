// lib/screens/add_product_screen.dart
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
  final _quantityController =
      TextEditingController(); // Добавлен контроллер для количества
  String _selectedProductName = '';
  String _selectedProductGroup = '';

  void _submitData() {
    if (_selectedProductName.isEmpty ||
        _priceController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _selectedProductGroup.isEmpty) {
      return;
    }

    final enteredPrice = double.parse(_priceController.text);
    final enteredQuantity =
        double.parse(_quantityController.text); // Получение количества
    if (enteredPrice <= 0 || enteredQuantity <= 0) {
      return;
    }

    widget.addProduct(_selectedProductName, enteredPrice, enteredQuantity,
        _selectedProductGroup);
    _priceController.clear();
    _quantityController.clear(); // Очистка поля количества
    setState(() {
      _selectedProductName = '';
      _selectedProductGroup = '';
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить товар'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DropdownButton<String>(
              value:
                  _selectedProductGroup.isEmpty ? null : _selectedProductGroup,
              hint: Text('Выбрать группу'),
              items: widget.productGroups
                  .map((productGroup) => DropdownMenuItem<String>(
                        value: productGroup.name,
                        child: Text(productGroup.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProductGroup = value!;
                  _selectedProductName = '';
                });
              },
            ),
            DropdownButton<String>(
              value: _selectedProductName.isEmpty ? null : _selectedProductName,
              hint: Text('Выбрать товар'),
              items: widget.productNames
                  .where((productName) =>
                      productName.group == _selectedProductGroup)
                  .map((productName) => DropdownMenuItem<String>(
                        value: productName.name,
                        child: Text(productName.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProductName = value!;
                });
              },
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Цена за еденицу'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _quantityController, // Поле для ввода количества
              decoration: InputDecoration(labelText: 'Количество'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Добавить товар'),
            ),
          ],
        ),
      ),
    );
  }
}
