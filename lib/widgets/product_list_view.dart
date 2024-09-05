import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/data_provider.dart';
import '../models/product.dart';
import 'package:intl/intl.dart';

class ProductListView extends StatelessWidget {
  final List<Product> products;
  final List<ProductName> productNames;
  final Function(Product) onEdit;
  final Function(Product) onDelete;
  // Экземпляр класса DataProvider для управления данными
  final DataProvider dataProvider;
  ProductListView(
      { required this.dataProvider,
      required this.products, required this.productNames,required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final groupedProducts = _groupProductsByDateAndCategory(products, productNames);

    return ListView(
      children: groupedProducts.entries.map((dateEntry) {
        final totalForDate = _calculateTotalForDate(
            dateEntry.value.values.expand((x) => x).toList());

        return ExpansionTile(
          title: Text(
              '${dateEntry.key} - Итого: ${totalForDate.toStringAsFixed(2)}'),
          children: dateEntry.value.entries.map((groupEntry) {
            final groupTotals = _calculateTotalForGroup(groupEntry.value);
            return ExpansionTile(
              title: Text(
                  '${dataProvider.getGroupNameById(groupEntry.key)} - Итого: ${groupTotals['totalAmount'].toStringAsFixed(2)}, (${groupTotals['totalItems']})'),
              children: groupEntry.value.map((product) {
                return ListTile(
                  title: Text(dataProvider.getProductNameById(product.productCode)),
                  subtitle: Text(
                    'Цена: ${product.price.toStringAsFixed(2)} x ${product.quantity.toStringAsFixed(2)} = ${(product.price * product.quantity).toStringAsFixed(2)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => onEdit(product)),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => onDelete(product)),
                    ],
                  ),
                );
              }).toList(),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  // Map<String, Map<String, List<Product>>> _groupProductsByDateAndCategory(
  //     List<Product> products) {
  //   final Map<String, Map<String, List<Product>>> groupedProducts = {};

  //   for (var product in products) {
  //     String formattedDate = DateFormat('dd/MM/yyyy').format(product.date);
  //     if (!groupedProducts.containsKey(formattedDate)) {
  //       groupedProducts[formattedDate] = {};
  //     }
  //     if (!groupedProducts[formattedDate]!.containsKey(product.groupCode)) {
  //       groupedProducts[formattedDate]![product.groupCode] = [];
  //     }
  //     groupedProducts[formattedDate]![product.groupCode]!.add(product);
  //   }

  //   return groupedProducts;
  // }
Map<String, Map<String, List<Product>>> _groupProductsByDateAndCategory(
      List<Product> products, List<ProductName> productNames) {
    final Map<String, Map<String, List<Product>>> groupedProducts = {};

    for (var product in products) {
      // Получаем информацию о продукте из productNames по productCode
      var productName = productNames.firstWhere(
        (p) => p.productCode == product.productCode,
        orElse: () => throw Exception(
            'ProductName not found for code ${product.productCode}'),
      );

      // Форматируем дату
      String formattedDate = DateFormat('dd/MM/yyyy').format(product.date);

      // Проверяем и добавляем данные в структуру groupedProducts
      if (!groupedProducts.containsKey(formattedDate)) {
        groupedProducts[formattedDate] = {};
      }
      if (!groupedProducts[formattedDate]!.containsKey(productName.groupCode)) {
        groupedProducts[formattedDate]![productName.groupCode] = [];
      }

      // Добавляем продукт в соответствующую группу
      groupedProducts[formattedDate]![productName.groupCode]!.add(product);
    }

    return groupedProducts;
  }

  double _calculateTotalForDate(List<Product> products) {
    return products.fold(0.0, (sum, product) {
      return sum + (product.price * product.quantity);
    });
  }

  Map<String, dynamic> _calculateTotalForGroup(List<Product> products) {
    double totalAmount = 0.0;
    int totalItems = 0;

    for (var product in products) {
      totalAmount += product.price * product.quantity;
      totalItems += 1;
    }

    return {
      'totalAmount': totalAmount,
      'totalItems': totalItems,
    };
  }
}
