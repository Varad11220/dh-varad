import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'basescaffold.dart';
import 'booking_detail_page.dart'; // Import the booking detail page

class mybooking extends StatefulWidget {
  @override
  _mybookingState createState() => _mybookingState();
}

class _mybookingState extends State<mybooking> {
  List<Map<String, dynamic>> bookings =
      []; // List to store all bookings with details
  bool isLoading = true; // Flag to show loading indicator

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
          FirebaseDatabase.instance.ref('serviceBooking/$userPhoneNumber');
      try {
        final snapshot = await databaseRef.get();

        if (snapshot.exists) {
          final data = snapshot.value as Map<Object?, Object?>?;
          if (data != null) {
            bookings.clear(); // Clear previous data before adding new entries

            // Loop through each booking entry
            data.forEach((bookingID, booking) {
              final bookingMap = booking as Map<Object?, Object?>?;
              final servicesDetails =
                  bookingMap?['servicesDetails'] as Map<Object?, Object?>?;
              final cost = bookingMap?['cost'] as Map<Object?, Object?>?;

              if (servicesDetails != null && cost != null) {
                final services = servicesDetails['services'] as List<dynamic>?;
                final serviceTime = servicesDetails['serviceTime'] as String?;
                final serviceDate = servicesDetails['serviceDate'] as String?;
                final totalAmount = cost['totalAmount'] as int?;
                final bookingTime = bookingMap?['bookingTime'] as String?;
                final serviceProvider =
                    bookingMap?['service_provider'] as String?;

                if (services != null &&
                    totalAmount != null &&
                    bookingTime != null) {
                  bookings.add({
                    'bookingTime': bookingTime,
                    'totalAmount': totalAmount,
                    'serviceTime': serviceTime,
                    'serviceDate': serviceDate,
                    'services': services,
                    'serviceProvider': serviceProvider,
                    'imagePath':
                        _getImagePath(serviceProvider), // Get the image path
                  });
                }
              }
            });

            setState(() {
              isLoading = false; // Data fetched, stop loading
            });

            // Log the bookings for debugging
            print("Bookings: $bookings");
          } else {
            setState(() {
              bookings = [];
              isLoading = false; // No data found, stop loading
            });
          }
        } else {
          setState(() {
            bookings = [];
            isLoading = false; // No data found, stop loading
          });
        }
      } catch (error) {
        setState(() {
          isLoading = false; // Stop loading on error
        });
        print('Error fetching data: $error');
      }
    } else {
      setState(() {
        isLoading = false; // User phone number not found, stop loading
      });
    }
  }

  // Method to get the image path based on service provider name
  String _getImagePath(String? serviceProvider) {
    switch (serviceProvider) {
      case 'Electrician':
        return 'assets/electrician.png';
      case 'Plumber':
        return 'assets/plumber.png';
      case 'Househelp':
        return 'assets/househelp.png';
      case 'Laundry':
        return 'assets/laundry.png';
      case 'Gardener':
        return 'assets/gardener.png';
      case 'Grocery':
        return 'assets/grocery.png';
      case 'Bicycle Booking':
        return 'assets/bicycle.png';
      case 'Local Transport':
        return 'assets/transport.png';
      case 'Turf & Club':
        return 'assets/turf.png';
      default:
        return 'assets/default.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "My Bookings",
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookings.isNotEmpty
              ? ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];

                    return GestureDetector(
                      onTap: () {
                        // Inside your GestureDetector onTap function
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingDetailPage(
                              serviceProvider: booking['serviceProvider'],
                              services: booking[
                                  'services'], // Pass the fetched services here
                              serviceDate: booking['serviceDate'],
                              serviceTime: booking['serviceTime'],
                              totalCost: booking['totalAmount']
                                  .toDouble(), // Ensure the type is double
                              bookingTime: booking[
                                  'bookingTime'], // Pass the booking time
                            ),
                          ),
                        );
                      },
                      child: BookingCard(
                        serviceProvider: booking['serviceProvider'],
                        bookingTime: booking['bookingTime'],
                        serviceTime: booking['serviceTime'],
                        totalCost: booking['totalAmount'].toDouble(),
                        imageUrl: booking['imagePath'],
                      ),
                    );
                  },
                )
              : Center(
                  child: const Text(
                    "No bookings yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String serviceProvider;
  final String bookingTime;
  final String serviceTime;
  final double totalCost;
  final String imageUrl;

  BookingCard({
    required this.serviceProvider,
    required this.bookingTime,
    required this.serviceTime,
    required this.totalCost,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Provider: $serviceProvider',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Booking Time: $bookingTime'),
                  SizedBox(height: 8),
                  Text('Service Time: $serviceTime'),
                  SizedBox(height: 8),
                  Text(
                    'Total Cost: ₹$totalCost',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
