import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class FoodBooking extends StatefulWidget {
  @override
  _FoodBookingState createState() => _FoodBookingState();
}

class _FoodBookingState extends State<FoodBooking> {
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookedServices();
  }

  Future<void> _fetchBookedServices() async {
    final prefs = await SharedPreferences.getInstance();
    final userPhoneNumber = prefs.getString('userPhoneNumber');

    if (userPhoneNumber != null) {
      final databaseRef =
          FirebaseDatabase.instance.ref('foodOrders/$userPhoneNumber');
      print('Fetching bookings for user: $userPhoneNumber');

      try {
        final snapshot = await databaseRef.get();
        if (snapshot.exists) {
          final data = snapshot.value as Map<Object?, Object?>?;

          if (data != null) {
            bookings.clear();

            for (var entry in data.entries) {
              final booking = entry.value as Map<Object?, Object?>?;
              if (booking != null) {
                // Extract booking details
                final orderTime = booking['orderTime'] as String?;
                final totalCost = (booking['totalCost'] is int)
                    ? (booking['totalCost'] as int).toDouble()
                    : booking['totalCost'] as double?;
                final deliveryDate = booking['deliveryDate'] as String?;
                final deliveryTime = booking['deliveryTime'] as String?;
                final items = booking['orderDetails'] as List<dynamic>?;
                // final orderStatus = booking['status'] as String?;
                final orderStatus = '2' as String?;
                final gstAmount = (booking['gstAmount'] is int)
                    ? (booking['gstAmount'] as int).toDouble()
                    : booking['gstAmount'] as double?;

                if (orderTime != null && totalCost != null) {
                  bookings.add({
                    'orderTime': orderTime,
                    'totalCost': totalCost,
                    'deliveryDate': deliveryDate,
                    'deliveryTime': deliveryTime,
                    'items': items,
                    'gstAmount': gstAmount,
                    'grandTotal': (booking['grandTotal'] is int)
                        ? (booking['grandTotal'] as int).toDouble()
                        : booking['grandTotal'] as double?,
                    'status': orderStatus,
                  });
                }
              }
            }

            bookings.sort((a, b) => a['orderTime'].compareTo(b['orderTime']));
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              bookings = [];
              isLoading = false;
            });
          }
        } else {
          setState(() {
            bookings = [];
            isLoading = false;
          });
        }
      } catch (error) {
        print('Error fetching data: $error');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case '1':
        return Colors.blue; // Order Placed
      case '2':
        return Colors.orange; // In the Kitchen
      case '3':
        return Colors.yellow; // On the Way
      case '4':
        return Colors.green; // Delivered
      default:
        return Colors.grey; // Unknown status
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case '1':
        return 'Order Placed';
      case '2':
        return 'In the Kitchen';
      case '3':
        return 'On the Way';
      case '4':
        return 'Delivered';
      default:
        return 'Unknown Status';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookings.isNotEmpty
              ? ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final order = bookings[index];
                    return OrderCard(
                      orderTime: order['orderTime'] as String? ?? '',
                      totalCost: order['totalCost'] as double? ?? 0.0,
                      gstAmount: order['gstAmount'] as double? ?? 0.0,
                      grandTotal: order['grandTotal'] as double? ?? 0.0,
                      deliveryDate: order['deliveryDate'] as String? ?? '',
                      deliveryTime: order['deliveryTime'] as String? ?? '',
                      orderDetails: order['items'] as List<dynamic>? ?? [],
                      status: _getStatusText(
                          order['status'] as String?), // Pass status text
                      statusColor: _getStatusColor(
                          order['status'] as String?), // Pass status color
                    );
                  },
                )
              : Center(
                  child: const Text(
                    "No orders yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderTime;
  final double totalCost;
  final double gstAmount;
  final double grandTotal;
  final String deliveryDate;
  final String deliveryTime;
  final List<dynamic> orderDetails;
  final String status; // New variable for order status
  final Color statusColor; // New variable for order status color

  OrderCard({
    required this.orderTime,
    required this.totalCost,
    required this.gstAmount,
    required this.grandTotal,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.orderDetails,
    required this.status,
    required this.statusColor, // Initialize status color
  });

  @override
  Widget build(BuildContext context) {
    // Number formatting for currency
    final currencyFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: 'Rs ', decimalDigits: 2);

    return GestureDetector(
      onTap: () {
        // Navigate to order details page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsPage(
              orderTime: orderTime,
              deliveryDate: deliveryDate,
              deliveryTime: deliveryTime,
              orderDetails: orderDetails,
              gstAmount: gstAmount,
              grandTotal: grandTotal,
              status: status, // Pass status
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Time: $orderTime',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text('Delivery Date: $deliveryDate',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Delivery Time: $deliveryTime',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text(
                'Grand Total: ${currencyFormat.format(grandTotal)}',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status: $status',
                    style: TextStyle(color: statusColor, fontSize: 16),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetailsPage extends StatelessWidget {
  final String orderTime;
  final String deliveryDate;
  final String deliveryTime;
  final List<dynamic> orderDetails;
  final double gstAmount;
  final double grandTotal;
  final String status;

  OrderDetailsPage({
    required this.orderTime,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.orderDetails,
    required this.gstAmount,
    required this.grandTotal,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // Number formatting for currency
    final currencyFormat =
        NumberFormat.currency(locale: 'en_IN', symbol: 'Rs ', decimalDigits: 2);
    double parsePrice(String price) {
      // Remove "Rs " prefix and any non-numeric characters
      return double.tryParse(price
              .replaceAll('Rs ', '')
              .replaceAll('-', '')
              .replaceAll(RegExp(r'[^\d.]'), '')) ??
          0.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Time: $orderTime', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Delivery Date: $deliveryDate',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Delivery Time: $deliveryTime',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Item', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            for (var item in orderDetails)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item['quantity']}', style: TextStyle(fontSize: 14)),
                    Flexible(
                      child: Text(
                        item['title'],
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(currencyFormat.format(parsePrice(item['price'])),
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            SizedBox(height: 8),
            // GST and Grand Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('GST Amount:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(currencyFormat.format(gstAmount),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Grand Total:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(currencyFormat.format(grandTotal),
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
              ],
            ),
            SizedBox(height: 16),
            Text('Status: $status', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
