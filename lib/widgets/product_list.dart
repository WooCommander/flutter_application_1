// lib/widgets/product_list.dart
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;

  ProductList(this.products);

  @override
  Widget build(BuildContext context) {
    final groupedProducts = _groupProductsByCategory(products);

    return ListView.builder(
      itemCount: groupedProducts.length,
      itemBuilder: (ctx, index) {
        final group = groupedProducts.keys.elementAt(index);
        final groupProducts = groupedProducts[group]!;

        return ExpansionTile(
          title: Text(group),
          children: groupProducts
              .map((product) => ListTile(
                    title: Text(product.name),
                    subtitle: Text(product.price.toString()),
                    trailing: Text(
                      '${product.date.day}/${product.date.month}/${product.date.year}',
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
