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
  String _selectedProductName = '';
  String _selectedProductGroup = '';

  @override
  void initState() {
    super.initState();
    if (widget.productNames.isNotEmpty) {
      _selectedProductName = widget.productNames.first.name;
    }
    if (widget.productGroups.isNotEmpty) {
      _selectedProductGroup = widget.productGroups.first.name;
    }
  }

  void _submitData() {
    final enteredPrice = double.tryParse(_priceController.text) ?? 0;
    final enteredQuantity = double.tryParse(_quantityController.text) ?? 0;

    if (enteredPrice <= 0 || enteredQuantity <= 0 || _selectedProductName.isEmpty || _selectedProductGroup.isEmpty) {
      return;
    }

    widget.addProduct(_selectedProductName, enteredPrice, enteredQuantity, _selectedProductGroup);
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
          children: [
            // Существующие группы
            DropdownButton<String>(
              value: _selectedProductGroup.isEmpty ? null : _selectedProductGroup,
              hint: Text('Выберите группу'),
              items: widget.productGroups.map((group) {
                return DropdownMenuItem(
                  value: group.name,
                  child: Text(group.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProductGroup = value!;
                });
              },
            ),
            // Существующие товары
            DropdownButton<String>(
              value: _selectedProductName.isEmpty ? null : _selectedProductName,
              hint: Text('Выберите товар'),
              items: widget.productNames
                  .where((productName) => productName.group == _selectedProductGroup)
                  .map((product) {
                    return DropdownMenuItem(
                      value: product.name,
                      child: Text(product.name),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProductName = value!;
                });
              },
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Цена за единицу'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Количество'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
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
