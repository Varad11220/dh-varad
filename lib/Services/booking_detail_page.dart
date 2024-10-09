import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingDetailPage extends StatelessWidget {
  final String serviceProvider;
  final List<dynamic> services; // List of services fetched from Firebase
  final String? serviceDate;
  final String? serviceTime;
  final double totalCost; // Total cost of the booking
  final String bookingTime;
  final String selectedService;
  final bool showCancelButton;
  final bool isCancelled;

  BookingDetailPage({
    required this.serviceProvider,
    required this.services,
    this.serviceDate,
    this.serviceTime,
    required this.totalCost,
    required this.bookingTime,
    required this.selectedService,
    this.showCancelButton = false,
    required this.isCancelled, // Include booking time in the constructor
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
                      Text(selectedService,
                        style: TextStyle(fontSize: 14, height: 1.5),),
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
      bottomNavigationBar: showCancelButton && !isCancelled// Show button based on the flag
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: Text('Confirm Cancellation'),
                      content: Text(
                          'Are you sure you want to cancel this booking?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Handle the cancellation logic here
                            cancelBooking(); // Call the function to cancel the booking
                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.of(context)
                                .pop(); // Navigate back to My Bookings page
                          },
                          child: Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('No'),
                        ),
                      ],
                    ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              backgroundColor: Colors.red.shade500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(21.0),
              ),
            ),
            child: const Text(
              'Cancel Booking',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      )
          : null, // Don't show anything if showCancelButton is false
    );
  }

  Future<void> cancelBooking() async {
    final prefs = await SharedPreferences.getInstance();
    final databaseReference = FirebaseDatabase.instance.ref('serviceBooking');
    final userPhoneNumber = prefs.getString('userPhoneNumber');

    if (userPhoneNumber != null) {
      // Normalize the format of bookingTime by replacing any hyphens with spaces
      final normalizedBookingTime = bookingTime.replaceAll('-', ' ');

      // Fetch the user's bookings from the database
      final snapshot = await databaseReference.child(userPhoneNumber).get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        // Loop through each booking to find the one with the matching bookingTime
        String bookingKeyToUpdate = '';
        for (var entry in data.entries) {
          final booking = entry.value as Map<dynamic, dynamic>?;
          if (booking != null) {
            // Normalize the bookingTime from the database for comparison
            final dbBookingTime = (booking['bookingTime'] as String).replaceAll('-', ' ');

            if (dbBookingTime == normalizedBookingTime) {
              bookingKeyToUpdate = entry.key;
              break;
            }
          }
        }

        if (bookingKeyToUpdate.isNotEmpty) {
          // Set the 'cancelBooking' field to true for the found booking
          await databaseReference
              .child(userPhoneNumber)
              .child(bookingKeyToUpdate)
              .child('cancelBooking')
              .set(true);

          print('Booking cancellation updated successfully.');
        } else {
          print('Error: Booking with the specified time not found.');
        }
      } else {
        print('Error: No bookings found for this user.');
      }
    } else {
      print('Error: userPhoneNumber is null');
    }
  }
}