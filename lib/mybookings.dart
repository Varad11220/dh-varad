import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'basescaffold.dart';
import 'booking_detail_page.dart'; // Import the booking detail page

class MyBooking extends StatefulWidget {
  @override
  _MyBookingState createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  List<Map<String, dynamic>> bookings =
      []; // List to store all bookings with details
  bool isLoading = true; // Flag to show loading indicator

  // Map for storing specific image URLs for each service provider
  Map<String, String> serviceProviderImageUrls = {
    'Electrician':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217108.jpg?alt=media&token=b77f7549-74ef-49c9-ad77-26e0eb94aa52',
    'Plumber':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217096.jpg?alt=media&token=d41ecdf4-fc91-427d-8429-2ec4e4ba015f',
    'Househelp':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217106.jpg?alt=media&token=d6ceb594-ed38-42d4-b351-eb13184132d9',
    'Laundry':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217092.jpg?alt=media&token=0c9b7b90-30d4-4657-8ddd-c065839de97c',
    'Gardener':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217089.jpg?alt=media&token=f17fc776-58ce-4abe-9967-5379131f6f8c',
    'Grocery':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217109.jpg?alt=media&token=952144b4-1589-410a-8e53-16629c554238',
    'Bicycle Booking':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217101.jpg?alt=media&token=b05deb6c-f9d9-4fe0-8857-00dd186d6668',
    'Local Transport':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217098.jpg?alt=media&token=1b8b70e9-29d3-430f-86fa-b35b947f1903',
    'Turf & Club':
        'https://firebasestorage.googleapis.com/v0/b/doodleshomes-7ffe2.appspot.com/o/images%2F1001217103.jpg?alt=media&token=206fe6c6-3f94-4e34-a30d-2c7eccf41ca5',
  };

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
            for (var entry in data.entries) {
              final bookingID = entry.key;
              final booking = entry.value as Map<Object?, Object?>?;
              final servicesDetails =
                  booking?['servicesDetails'] as Map<Object?, Object?>?;
              final cost = booking?['cost'] as Map<Object?, Object?>?;

              if (servicesDetails != null && cost != null) {
                final services = servicesDetails['services'] as List<dynamic>?;
                final serviceTime = servicesDetails['serviceTime'] as String?;
                final serviceDate = servicesDetails['serviceDate'] as String?;
                final totalAmount = cost['totalAmount'] as int?;
                final bookingTime = booking?['bookingTime'] as String?;
                final serviceProvider = booking?['service_provider'] as String?;

                // Get the specific image URL from the map
                String imageUrl =
                    serviceProviderImageUrls[serviceProvider ?? ''] ?? '';

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
                    'imageUrl': imageUrl, // Use the static image URL
                  });
                }
              }
            }

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

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "My Bookings",
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching data
          : bookings.isNotEmpty
              ? ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];

                    return GestureDetector(
                      onTap: () {
                        // Navigate to the detailed booking page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingDetailPage(
                              serviceProvider:
                                  booking['serviceProvider'] as String? ?? '',
                              selectedService: (booking['services']
                                          as List<dynamic>?)
                                      ?.map((service) =>
                                          service['name'] as String?)
                                      .where((name) =>
                                          name != null) // Filter out null names
                                      .join(", ") ??
                                  '', // Join service names
                              serviceDate:
                                  booking['serviceDate'] as String? ?? '',
                              serviceTime:
                                  booking['serviceTime'] as String? ?? '',
                              totalCost: (booking['totalAmount'] as int?)
                                      ?.toDouble() ??
                                  0.0,
                              bookingTime: '',
                              services: [],
                            ),
                          ),
                        );
                      },
                      child: BookingCard(
                        serviceProvider: booking['serviceProvider'],
                        bookingTime: booking['bookingTime'],
                        serviceTime: booking['serviceTime'],
                        totalCost: booking['totalAmount'].toDouble(),
                        imageUrl: booking[
                            'imageUrl'], // Use the image URL from bookings
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
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black, width: 2), // Border color and width
                borderRadius: BorderRadius.circular(10.0), // Border radius
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.5),
                child: Image.network(
                  alignment: Alignment.bottomRight,
                  imageUrl.isEmpty
                      ? 'https://via.placeholder.com/110'
                      : imageUrl,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
