import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FoodBillSummeryPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final DateTime? date; // Accept date parameter
  final TimeOfDay? time; // Accept time parameter

  FoodBillSummeryPage({
    required this.cartItems,
    this.date,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize totalCost
    double totalCost = 0;

    // Calculate totalCost
    cartItems.forEach((item) {
      totalCost +=
          double.parse(item['price'].replaceAll('₹ ', '')) * item['quantity'];
    });

    // Calculate GST and grand total
    const double gstPercentage = 0.18; // 18%
    double gstAmount = totalCost * gstPercentage;
    double grandTotal = totalCost + gstAmount;

    // Format the booking date and time
    String formattedDate =
        date != null ? DateFormat('yMMMMd').format(date!) : 'No date selected';
    String formattedTime =
        time != null ? time!.format(context) : 'No time selected';

    // Build UI
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bill Summary',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            // Delivery Time Section
            Text(
              'Delivery Time',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '$formattedDate at $formattedTime', // Display formatted date and time
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 16),
            // Address Section
            Text(
              'Address',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'deliveryAddress',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 24),

            Text(
              'Order Summary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add the Billing Details heading
                  Text(
                    'Billing Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16), // Add some spacing after the heading
                  // Individual items
                  ...cartItems.map((item) {
                    return Column(
                      children: [
                        buildBillingDetail(
                          item['title'],
                          item['quantity'], // Pass quantity
                          double.parse(item['price'].replaceAll('₹ ', '')) *
                              item['quantity'],
                        ),
                        SizedBox(height: 8),
                      ],
                    );
                  }).toList(),
                  Divider(),
                  // Total Price
                  buildBillingDetail('Total', 0, grandTotal,
                      isTotal: true), // Set quantity to 0 for total
                ],
              ),
            ),
            SizedBox(height: 24), // Additional spacing
          ],
        ),
      ),
      // Bottom Button
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            // Handle Payment Navigation
          },
          child: Text(
            'Proceed to Payment',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[800],
            padding: EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for displaying billing items
  Widget buildBillingDetail(String item, int quantity, double price,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isTotal
              ? item
              : '$item (x$quantity)', // Show quantity only for non-total items
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '₹${price.toStringAsFixed(2)}', // Changed from '$' to '₹'
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
