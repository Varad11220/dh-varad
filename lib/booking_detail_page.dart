import 'package:flutter/material.dart';

class BookingDetailPage extends StatelessWidget {
  final String serviceProvider;
  final List<dynamic> services; // List of services fetched from Firebase
  final String? serviceDate;
  final String? serviceTime;
  final double totalCost; // Total cost of the booking
  final String bookingTime; // New parameter for booking time

  BookingDetailPage({
    required this.serviceProvider,
    required this.services,
    this.serviceDate,
    this.serviceTime,
    required this.totalCost,
    required this.bookingTime, // Include booking time in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$serviceProvider Details'),
        backgroundColor: Colors.purple[100],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Centered Booking Time Display
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Booking Time: $bookingTime',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.build_rounded,
                        size: 50,
                        color: Colors.purple[200],
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$serviceProvider Service',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[900],
                            ),
                          ),
                          // Removed service date and time display
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Selected Services List
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Services',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[900],
                        ),
                      ),
                      SizedBox(height: 8),
                      // List of selected services
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          return Text(
                            '${service['name']} - ₹${service['price']}',
                            style: TextStyle(fontSize: 16),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Total Cost Section
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.attach_money, color: Colors.green),
                        title: Text('Total Cost'),
                        subtitle: Text('₹$totalCost'),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.timer, color: Colors.purple[300]),
                        title: Text('Service Time'),
                        subtitle: Text('$serviceTime'),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.calendar_today, color: Colors.blue),
                        title: Text('Service Date'),
                        subtitle: Text('$serviceDate'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
