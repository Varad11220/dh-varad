import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:background_sms/background_sms.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import the Fluttertoast package

class FoodBillSummaryPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final DateTime? date; // Accept date parameter
  final TimeOfDay? time; // Accept time parameter

  FoodBillSummaryPage({
    required this.cartItems,
    this.date,
    this.time,
  });

  @override
  _FoodBillSummaryPageState createState() => _FoodBillSummaryPageState();
}

class _FoodBillSummaryPageState extends State<FoodBillSummaryPage> {
  String? userPhoneNumber;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userPhoneNumber = prefs.getString('userPhoneNumber');
    });
  }

  Future<bool> _isPermissionGranted() async =>
      await Permission.sms.status.isGranted;

  Future<void> _sendMessage(String phoneNumber, String message,
      {int? simSlot}) async {
    var result = await BackgroundSms.sendMessage(
      phoneNumber: phoneNumber,
      message: message,
      simSlot: simSlot,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (result == SmsStatus.sent) {
        Fluttertoast.showToast(
          msg: "SMS Sent: Your order has been placed!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to send SMS",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize totalCost
    double totalCost = 0;

    // Calculate totalCost
    widget.cartItems.forEach((item) {
      totalCost +=
          double.parse(item['price'].replaceAll('₹ ', '')) * item['quantity'];
    });

    // Calculate GST and grand total
    const double gstPercentage = 0.18; // 18%
    double gstAmount = totalCost * gstPercentage;
    double grandTotal = totalCost + gstAmount;

    // Format the booking date and time
    String formattedDate = widget.date != null
        ? DateFormat('yMMMMd').format(widget.date!)
        : 'No date selected';
    String formattedTime =
        widget.time != null ? widget.time!.format(context) : 'No time selected';

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
                  Text(
                    'Billing Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Individual items
                  ...widget.cartItems.map((item) {
                    return Column(
                      children: [
                        buildBillingDetail(
                          item['title'],
                          item['quantity'],
                          double.parse(item['price'].replaceAll('₹ ', '')) *
                              item['quantity'],
                        ),
                        SizedBox(height: 8),
                      ],
                    );
                  }).toList(),
                  Divider(),
                  // Total Price
                  buildBillingDetail('Total', 0, grandTotal, isTotal: true),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Proceed to Payment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (userPhoneNumber == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('User phone number not found')),
                    );
                    return;
                  }

                  final dateTime =
                      DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now());

                  final databaseRef = FirebaseDatabase.instance
                      .ref('foodOrders/$userPhoneNumber')
                      .child(dateTime);
                  await databaseRef.set({
                    'orderDetails': widget.cartItems
                        .map((item) => {
                              'title': item['title'],
                              'quantity': item['quantity'],
                              'price': item['price'],
                            })
                        .toList(),
                    'orderTime': dateTime,
                    'totalCost': totalCost,
                    'gstAmount': gstAmount,
                    'grandTotal': grandTotal,
                    'deliveryDate': formattedDate,
                    'deliveryTime': formattedTime,
                  }).then((_) async {
                    if (await _isPermissionGranted()) {
                      _sendMessage(
                        userPhoneNumber!,
                        "Your total bill is ₹ ${grandTotal.toStringAsFixed(2)}",
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: "SMS permission not granted!",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  });

                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.orange[800],
                ),
                child: const Text('Proceed to Payment'),
              ),
            ),
          ],
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
          isTotal ? item : '$item (x$quantity)',
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '₹${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
