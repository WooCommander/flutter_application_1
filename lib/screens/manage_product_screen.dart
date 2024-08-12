// lib/screens/manage_product_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/product_group.dart';
import '../screens/edit_product_screen.dart';

class ManageProductScreen extends StatefulWidget {
  final Function(String, String) addProductName;
  final List<ProductGroup> productGroups;
  final Function(String) addProductGroup;
  final List<ProductName> productNames;
  final Function(String, String) editProductName;

  ManageProductScreen({
    required this.addProductName,
    required this.productGroups,
    required this.addProductGroup,
    required this.productNames,
    required this.editProductName,
  });

  @override
  _ManageProductScreenState createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  final _productNameController = TextEditingController();
  final _productGroupController = TextEditingController();
  String _selectedProductGroup = '';

  void _submitProductName() {
    if (_productNameController.text.isEmpty || _selectedProductGroup.isEmpty) {
      return;
    }

    widget.addProductName(_productNameController.text, _selectedProductGroup);
    _productNameController.clear();
    setState(() {
      _selectedProductGroup = '';
    });
  }

  void _submitProductGroup() {
    if (_productGroupController.text.isEmpty) {
      return;
    }

    widget.addProductGroup(_productGroupController.text);
    _productGroupController.clear();
  }

  void _editProductName() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditProductScreen(
        productNames: widget.productNames,
        editProductName: widget.editProductName,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Менеджер товаров'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _productGroupController,
              decoration: InputDecoration(labelText: 'Новая группа товаров'),
            ),
            ElevatedButton(
              onPressed: _submitProductGroup,
              child: Text('Добавить группу товаров'),
            ),
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
                });
              },
            ),
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(labelText: 'Новое название товара'),
            ),
            ElevatedButton(
              onPressed: _submitProductName,
              child: Text('Добавить товар'),
            ),
            TextButton(
              onPressed: _editProductName,
              child: Text('Редактировать товар'),
            ),
          ],
        ),
      ),
    );
  }
}
