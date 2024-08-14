import 'package:flutter/material.dart';

class MostPopularProduct extends StatelessWidget {
  final String name;
  final int count;
  final double? lowestPrice;

  const MostPopularProduct({
    required this.name,
    required this.count,
    this.lowestPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Самый популярный товар:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'Количество: $count',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            if (lowestPrice != null)
              Text(
                'Лучшая цена: ${lowestPrice!.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
