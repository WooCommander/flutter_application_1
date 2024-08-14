// lib/screens/edit_product_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  final List<ProductName> productNames;
  final Function(String, String) editProductName;

  EditProductScreen({
    required this.productNames,
    required this.editProductName,
  });

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  String _selectedProductName = '';
  final _newProductNameController = TextEditingController();

  void _submitData() {
    if (_selectedProductName.isEmpty ||
        _newProductNameController.text.isEmpty) {
      return;
    }

    widget.editProductName(
        _selectedProductName, _newProductNameController.text);
    _newProductNameController.clear();
    setState(() {
      _selectedProductName = '';
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать тоар'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DropdownButton<String>(
              value: _selectedProductName.isEmpty ? null : _selectedProductName,
              hint: Text('Выбери продукт для редактирования'),
              items: widget.productNames
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
              controller: _newProductNameController,
              decoration: InputDecoration(labelText: 'Новое название товара'),
            ),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Редактирование товара'),
            ),
          ],
        ),
      ),
    );
  }
}
