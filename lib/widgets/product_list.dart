import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onEdit;
  final Function(Product) onDelete;

  ProductList(this.products, {required this.onEdit, required this.onDelete});
  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat(
        'dd.MM.yyyy'); // Вы можете настроить формат по своему усмотрению
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final groupedProducts = _groupProductsByCategory(products);

    return ListView.builder(
      itemCount: groupedProducts.length,
      itemBuilder: (ctx, index) {
        final group = groupedProducts.keys.elementAt(index);
        final groupProducts = groupedProducts[group]!;

        return ExpansionTile(
          title: Text( '${group}, количество ${groupProducts.length}'),
          children: groupProducts
              .map((product) => ListTile(
                    title: Text(product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Делает текст жирным
                          fontSize: 18.0, // Увеличивает размер текста
                        )),
                    subtitle: Text(
                        'Цена: ${product.price.toStringAsFixed(2)}, Количество: ${product.quantity}, Сумма:${(product.price.toDouble() * product.quantity.toDouble()).toStringAsFixed(2)}, Дата: ${formatDate(product.date)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => onEdit(product),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => onDelete(product),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        );
      },
    );
  }

  Map<String, List<Product>> _groupProductsByCategory(List<Product> products) {
    final Map<String, List<Product>> groupedProducts = {};

    for (var product in products) {
      if (!groupedProducts.containsKey(product.group)) {
        groupedProducts[product.group] = [];
      }
      groupedProducts[product.group]!.add(product);
    }

    return groupedProducts;
  }
}
