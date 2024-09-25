import 'package:flutter/material.dart';

class BookingDetailPage extends StatelessWidget {
  final String serviceProvider;
  final String selectedService; // New parameter for selected service
  final String serviceDate;
  final String serviceTime;
  final double totalCost;

  BookingDetailPage({
    required this.serviceProvider,
    required this.selectedService, // Include selectedService in the constructor
    required this.serviceDate,
    required this.serviceTime,
    required this.totalCost,
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
                          Text(
                            'Date: $serviceDate',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          Text(
                            'Time: $serviceTime',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                        leading: Icon(Icons.build_rounded,
                            color: Colors.purple[300]),
                        title: Text('Selected Service'),
                        subtitle: Text('$selectedService'),
                      ),
                      Divider(),
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
