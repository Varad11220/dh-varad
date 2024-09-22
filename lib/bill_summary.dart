import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date and time
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'service_item.dart';
import 'package:firebase_database/firebase_database.dart'; // Ensure Firebase is initialized
import 'package:background_sms/background_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import the Fluttertoast package

class BillSummaryPage extends StatefulWidget {
  final List<ServiceItem> selectedServices;
  final int subTotal;
  final DateTime selectedDateTime;
  final String serviceImagePath; // New field for service image

  const BillSummaryPage({
    Key? key,
    required this.selectedServices,
    required this.subTotal,
    required this.selectedDateTime,
    required this.serviceImagePath, // Initialize the new field
  }) : super(key: key);

  @override
  _BillSummaryPageState createState() => _BillSummaryPageState();
}

class _BillSummaryPageState extends State<BillSummaryPage> {
  String? userPhoneNumber;
  String? yourSelectedServiceName;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userPhoneNumber = prefs.getString('userPhoneNumber');
      yourSelectedServiceName = prefs.getString('your_selected_service_name');
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
          msg: "SMS Sent: Your service has been booked!",
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
    final gst = (widget.subTotal * 0.18).round();
    final totalAmount = widget.subTotal + gst;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Bill Summary'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Name
            Center(
              child: Text(
                yourSelectedServiceName ?? "Service Name",
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Display the service image with the same styling as in ElectricianBookingPage
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.blue,
                  width: 3.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  widget.serviceImagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Service Date & Time
            Center(
              child: Text(
                'Service Date & Time: ${DateFormat('yyyy-MM-dd').format(widget.selectedDateTime)} ${DateFormat('HH:mm').format(widget.selectedDateTime)}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),

            // List of selected services
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedServices.length,
                itemBuilder: (context, index) {
                  final service = widget.selectedServices[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: Icon(
                        Icons.check_circle,
                        color: Colors.blueAccent,
                      ),
                      title: Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        '₹ ${service.price}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Sub Total
            _buildSummaryRow(
              label: 'Sub Total',
              value: '₹ ${widget.subTotal}',
            ),
            const SizedBox(height: 4),

            // GST
            _buildSummaryRow(
              label: 'GST (18%)',
              value: '₹ $gst',
            ),
            const SizedBox(height: 4),

            // Total Amount
            _buildSummaryRow(
              label: 'Total Amount',
              value: '₹ $totalAmount',
              isBold: true,
            ),
            const SizedBox(height: 20),

            // Confirm Booking Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Booking logic remains unchanged...
                },
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build summary rows
  Widget _buildSummaryRow({
    required String label,
    required String value,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
