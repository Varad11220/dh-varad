import 'package:flutter/material.dart';

class FoodOrderDetailPage extends StatelessWidget {
  final String orderTime;
  final double totalAmount;
  final List<dynamic>? foodItems;

  FoodOrderDetailPage({
    required this.orderTime,
    required this.totalAmount,
    required this.foodItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Time: $orderTime',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Food Items:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...?foodItems?.map((item) => Text(item['name'])).toList(),
            SizedBox(height: 16),
            Text(
              'Total Amount: ₹${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
